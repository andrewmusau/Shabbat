use "C:\Users\amus\Desktop\Shabbat data + files\Shabbat.dta", clear 
tab missing // 96 observations (48 games) without data on attendance
drop if missing ==2

gen timefromshabbat = (matchtimeISR- end)/(60*1000) // time from the begining of the game to the end of shabbat in minutes. Positive is that games after the end of shabbat. Negative are before the end of shabbat.


cap prog drop rmax
program define rmax, eclass
    syntax varname
    local coef `varlist'
    local rmax = `e(r2)'
    // Approximate max R2 iteratively
	local range = "-0.001, 0.001"
	local step = "0.0025"
    while !inrange(`r(beta)', `range'){
	    local rmax = `rmax' + `step'
        qui psacalc beta `coef', rmax(`rmax')
    }
    display "{bf:Max R2 that sets beta(`coef') ≈ 0 is }" `rmax'
    psacalc beta `coef', rmax(`rmax')
end


*Table 5
regress lnattendance shabbat lncapacity i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season
psacalc beta shabbat
rmax shabbat


*Table 6.1
regress lnattendance shabbat lncapacity i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if dow!=2 & dow!=3& dow!=4 
psacalc beta shabbat
rmax shabbat

*Table 6.2
regress lnattendance shabbat lncapacity i.dow i.venue i.teamhome mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if teamhome!=1 & teamhome!=2 & teamhome!=11 & teamhome!=12 & teamhome!=27 & teamhome!=28 & teamhome!=33 &  teamhome!=34 & teamhome!=39 & teamhome!=40
psacalc beta shabbat
rmax shabbat

*Table 6.3
regress lnattendance shabbat lncapacity i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.season if which==2
psacalc beta shabbat
rmax shabbat

*Table 7.1
regress lnattendance shabbat lncapacity i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if dow==6 
psacalc beta shabbat
rmax shabbat

*Table 7.2
regress lnattendance shabbat timefromshabbat  lncapacity i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if dow==6 & timefromshabbat>0
psacalc beta timefromshabbat



