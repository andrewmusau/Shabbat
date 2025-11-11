use "C:\Users\amus\Desktop\Shabbat data + files\Shabbat.dta", clear
tab missing // 96 observations (48 games) without data on attendance
drop if missing ==2

list team season which matchtimeISR date matchday if !attendance
drop if attendance ==0 // 2 observations (1 game) deleted Bnei Sakhnin vs Bnei Yehuda ion 23/02/2019

list team season date matchday if matchtimeISR==. //2 games that were scheduled during or just before the match because of the weather
drop if matchtimeISR==.

gen sharecapacity= attendance/ capacity

tab sharecapacity if sharecapacity>0.95 // 110 observations (55 games) with sold out games (share of capacity above 95%)

gen timefromshabbat = (matchtimeISR- end)/(60*1000) // time from the begining of the game to the end of shabbat in minutes. Positive is that games after the end of shabbat. Negative are before the end of shabbat.
gen timefromshabatsqured= timefromshabbat* timefromshabbat // squared term of time in shabbat in minutes

gen capacity95=0.95* capacity
gen lncapacity95perc=ln( capacity95) //for upper limit in tobit estimation as in Besters, L. M., van Ours, J. C., & van Tuijl, M. A. (2019). How outcome uncertainty, loss aversion and team quality affect stadium attendance in Dutch professional football. Journal of economic psychology, 72, 117-127.

*Distribution of days
tab dow
tab dow if dow==6 & shabbat==0
tab dow if dow==6 &  shabbat==1

****TABLE 1 IN THE PAPER****
recode shabbat (0=1) (1=0), gen(nonshabbat)
*TAG MATCHES
egen tag= tag(game)
dtable i.dow if tag, by(nonshabbat) factor(,statistic(fvfrequency)) 

*Table 2 Preliminaries
*Left panel
*Attendance per HOME team on shabbat
tabstat attendance if shabbat==1& home==1, by ( teamhome ) stat (mean sd min max n)

*Right panel
*Attendance per HOME team NOT on shabbat
tabstat attendance if shabbat==0& home==1, by ( teamhome ) stat (mean sd min max n)


****TABLE 2 IN THE PAPER****

recode team (17 = 1) (20 = 2) (14 = 3) (6 = 4) (1 = 5) (18 = 6) (10 = 7) (8 = 8) (2 = 9) (7 = 10) (19 = 11) (9 = 12) (15 = 13) (11 = 14) (4 = 15) (5 = 16) (12 = 17) (16 = 18) (3 = 19) (13 = 20), gen(tteam)

labmask tteam, values(teamname)

collect clear
table tteam if home & shabbat, statistic(mean attendance) statistic(sd attendance) ///
    statistic(min attendance) statistic(max attendance) statistic(count attendance) name(c1) nformat(%4.0f)
	
table tteam if home & !shabbat, statistic(mean attendance) statistic(sd attendance) ///
    statistic(min attendance) statistic(max attendance) statistic(count attendance) name(c2) nformat(%4.0f)

collect combine all= c1 c2	
collect label levels result count "N", modify
collect label levels result sd "SD", modify
collect label levels result min "Min", modify
collect label levels result max "Max", modify

collect layout (tteam) (collection#result) 


*Table 3 Preliminaries
*Left panel
*Attendance per AWAY team on shabbat
tabstat attendance if shabbat==1& home==0, by ( teamhome ) stat (mean sd min max n)

*Right panel
*Attendance per AWAY team NOT on shabbat
tabstat attendance if shabbat==0& home==0, by ( teamhome ) stat (mean sd min max n)



****TABLE 3 IN THE PAPER****
collect clear
drop tteam

recode team (1 = 1) (20 = 2) (6 = 3) (15 = 4) (16 = 5) (9 = 6) (17 = 7) (7 = 8) (12 = 9) (10 = 10) (14 = 11) (2 = 12) (18 = 13) (11 = 14) (3 = 15) (4 = 16) (8 = 17) (19 = 18) (5 = 19) (13 = 20), gen(tteam)
labmask tteam, values(teamname)
table tteam if !home & shabbat, statistic(mean attendance) statistic(sd attendance) ///
    statistic(min attendance) statistic(max attendance) statistic(count attendance) name(c1) nformat(%4.0f)
	
table tteam if !home & !shabbat, statistic(mean attendance) statistic(sd attendance) ///
    statistic(min attendance) statistic(max attendance) statistic(count attendance) name(c2) nformat(%4.0f)

collect combine all= c1 c2	
collect label levels result count "N", modify
collect label levels result sd "SD", modify
collect label levels result min "Min", modify
collect label levels result max "Max", modify

collect layout (tteam) (collection#result) 


***In Appendix
*Table A1 left panel
*Descriptives of attendance by HOME team on SATURDAY games only on SHABBAT

*Table A1 right panel
*Descriptives of attendance by HOME team on SATURDAY games only Not on SHABBAT
tabstat attendance if  home==1&dow==6 &shabbat==0, by ( teamhome ) stat (mean sd min max n)

****TABLE A1 IN THE PAPER****
collect clear
drop tteam

recode team (17 = 1) (20 = 2) (14 = 3) (6 = 4) (1 = 5) (18 = 6) (10 = 7) (8 = 8) (2 = 9) (7 = 10) (19 = 11) (9 =12) (15 = 13) (11 = 14) (4 = 15) (5 = 16) (12 = 17) (16 = 18) (3 = 19) (13 = 20), gen(tteam)
labmask tteam, values(teamname)
table tteam if home & dow==6& shabbat, statistic(mean attendance) statistic(sd attendance) ///
    statistic(min attendance) statistic(max attendance) statistic(count attendance) name(c1) nformat(%4.0f)
	
table tteam if home & dow==6& !shabbat, statistic(mean attendance) statistic(sd attendance) ///
    statistic(min attendance) statistic(max attendance) statistic(count attendance) name(c2) nformat(%4.0f)

collect combine all= c1 c2	
collect label levels result count "N", modify
collect label levels result sd "SD", modify
collect label levels result min "Min", modify
collect label levels result max "Max", modify

collect layout (tteam) (collection#result) 


*Table A2 left panel
*Descriptives of attendance by AWAY team on SATURDAY games only on SHABBAT
tabstat attendance if  home==0&dow==6 &shabbat==1, by ( teamhome ) stat (mean sd min max n)

*Table A2 right panel
*Descriptives of attendance by AWAY team on SATURDAY games only Not on SHABBAT
tabstat attendance if  home==0&dow==6 &shabbat==0, by ( teamhome ) stat (mean sd min max n)


****TABLE A2 IN THE PAPER****
collect clear
drop tteam

recode team (1 = 1) (20 = 2) (6 = 3) (15 = 4) (16 = 5) (9 = 6) (17 = 7) (7 = 8) (12 = 9) (10 = 10) (14 = 11) (2 = 12) (18 = 13) (11 = 14) (3 = 15) (4 = 16) (8 = 17) (19 = 18) (5 = 19) (13 = 20), gen(tteam)
labmask tteam, values(teamname)
table tteam if !home & dow==6& shabbat, statistic(mean attendance) statistic(sd attendance) ///
    statistic(min attendance) statistic(max attendance) statistic(count attendance) name(c1) nformat(%4.0f)
	
table tteam if !home & dow==6& !shabbat, statistic(mean attendance) statistic(sd attendance) ///
    statistic(min attendance) statistic(max attendance) statistic(count attendance) name(c2) nformat(%4.0f)

collect combine all= c1 c2	
collect label levels result count "N", modify
collect label levels result sd "SD", modify
collect label levels result min "Min", modify
collect label levels result max "Max", modify

collect layout (tteam) (collection#result) 


*Table 4 Preliminaries
*Descriptives of the main variables
tabstat attendance lnattendance capacity big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated , by (shabbat) stat (mean sd min max n) // add only numbers for shabbat and non-shabbat games for seasons and which (season phases) from below

*Descriptives for the phase of the season
tab which
tab shabbat if which==1
tab shabbat if which==2
tab shabbat if which==3

*Descriptives per season
tab shabbat if season==1
tab shabbat if season==2
tab shabbat if season==3
tab shabbat if season==4
tab shabbat if season==5
tab shabbat if season==6
tab shabbat if season==7

xi, noomit: tabstat i.which, by (shabbat) stat (mean sd min max n)
xi, noomit: tabstat i.season, by (shabbat) stat (mean sd min max n)

****TABLE 4 IN THE PAPER****
estimates clear

eststo m1: quietly estpost tabstat attendance lnattendance capacity big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated if shabbat, statistics(mean sd min max) columns(statistics)

forval i=1/3{
	count if shabbat & which==`i'
	scalar w`i'= `r(N)'
	estadd scalar w`i': m1 
}
forval i=1/7{
	count if shabbat & season==`i'
	scalar s`i'= `r(N)'
	estadd scalar s`i': m1
}  

eststo m2: quietly estpost tabstat attendance lnattendance capacity big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated if !shabbat, statistics(mean sd min max) columns(statistics)

forval i=1/3{
	count if !shabbat & which==`i'
	scalar w`i'= `r(N)'
	estadd scalar w`i': m2 
}
forval i=1/7{
	count if !shabbat & season==`i'
	scalar s`i'= `r(N)'
	estadd scalar s`i': m2
}  



local hook "\deflang1033\plain\fs24"
local pfmt "\paperw15840\paperh12240\landscape" // US letter

esttab m1 m2, replace cells("mean(fmt(a3) label(Mean)) sd(fmt(a3) label(SD)) min(fmt(a3) label(Min)) max(fmt(a3) label(Max))") substitute("`hook'" "`hook'`pfmt'") nomtitle nonumber label varwidth(40) stats(N w2 w1 w3 s1 s2 s3 s4 s5 s6 s7, labels(Total "Regular Season" "Championship Playoff" "Relegation Playoff" "Season 2012-2013" "Season 2013-2014" "Season 2014-2015" "Season 2015-2016" "Season 2016-2017" "Season 2017-2018" "Season 2018-2019") fmt(%4.0f))

*Appendix Table A3 Preliminaries
*Descriptives of the main variables on Saturday games
tabstat attendance lnattendance capacity big5 rainmm temperature_2mC  pos points distance probhome  matchday knowchamp knoweurope knowrelegated if dow==6, by (shabbat) stat (mean sd min max n)

*Descriptives for the phase of the season
tab which
tab shabbat if which==1 & dow==6
tab shabbat if which==2 & dow==6
tab shabbat if which==3 & dow==6

*Descriptives per season
tab shabbat if season==1 & dow==6
tab shabbat if season==2 & dow==6
tab shabbat if season==3 & dow==6
tab shabbat if season==4 & dow==6
tab shabbat if season==5 & dow==6
tab shabbat if season==6 & dow==6
tab shabbat if season==7 & dow==6

xi, noomit: tabstat i.which if dow==6, by (shabbat) stat (mean sd min max n)

****TABLE A3 IN THE PAPER****
estimates clear

eststo m1: quietly estpost tabstat attendance lnattendance capacity big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated if dow==6 & shabbat, statistics(mean sd min max) columns(statistics)

forval i=1/3{
	count if shabbat & which==`i'
	scalar w`i'= `r(N)'
	estadd scalar w`i': m1 
}
forval i=1/7{
	count if shabbat & season==`i'
	scalar s`i'= `r(N)'
	estadd scalar s`i': m1
}  

eststo m2: quietly estpost tabstat attendance lnattendance capacity big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated if dow==6 & !shabbat, statistics(mean sd min max) columns(statistics)

forval i=1/3{
	count if !shabbat & which==`i'
	scalar w`i'= `r(N)'
	estadd scalar w`i': m2 
}
forval i=1/7{
	count if !shabbat & season==`i'
	scalar s`i'= `r(N)'
	estadd scalar s`i': m2
}  



local hook "\deflang1033\plain\fs24"
local pfmt "\paperw15840\paperh12240\landscape" // US letter

esttab m1 m2, replace cells("mean(fmt(a3) label(Mean)) sd(fmt(a3) label(SD)) min(fmt(a3) label(Min)) max(fmt(a3) label(Max))") substitute("`hook'" "`hook'`pfmt'") nomtitle nonumber label varwidth(40) stats(N w2 w1 w3 s1 s2 s3 s4 s5 s6 s7, labels(Total "Regular Season" "Championship Playoff" "Relegation Playoff" "Season 2012-2013" "Season 2013-2014" "Season 2014-2015" "Season 2015-2016" "Season 2016-2017" "Season 2017-2018" "Season 2018-2019") fmt(%4.0f))

*Regresion analyses
*Table 5 Preliminaries
*Table with all the data
tobit lnattendance shabbat    ,ul ( lncapacity95perc ) vce (cluster  game)

tobit lnattendance shabbat lncapacity   ,ul ( lncapacity95perc ) vce (cluster  game)

tobit lnattendance shabbat lncapacity i.dow i.venue i.teamhome i.which i.season ,ul ( lncapacity95perc ) vce (cluster  game)

tobit lnattendance shabbat lncapacity i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season ,ul ( lncapacity95perc ) vce (cluster  game)

****TABLE 5 IN THE PAPER****
estimates clear
eststo: tobit lnattendance shabbat    ,ul ( lncapacity95perc ) vce (cluster  game)
eststo: tobit lnattendance shabbat lncapacity   ,ul ( lncapacity95perc ) vce (cluster  game)
eststo: tobit lnattendance shabbat lncapacity i.dow i.venue i.teamhome i.which i.season ,ul ( lncapacity95perc ) vce (cluster  game)

eststo: tobit lnattendance shabbat lncapacity i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season ,ul ( lncapacity95perc ) vce (cluster  game)

esttab, se keep(shabbat) indicate("Log of Stadium Capacity =lncapacity" "Day of the week dummies = *.dow" "Venue dummies= *.venue" "Home-team dummies = *2.teamhome"  "Away-team dummies = *5.teamhome" "Season dummies= *.season" "Phase of the season dummies = *.which" "Additional controls= rainmm" ) coeflabel(shabbat "Shabbat") eqlab(none) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_rc ll, labels("Observations" "Censored Observations" "Log pseudolikelihood") fmt(%3.0f)) b(3) mlab(none)  nonotes addnotes() replace


*Regresion analyses
*Table A4 Preliminaries
*Table with all the data

tobit lnattendance shabbat   ,ul ( lncapacity95perc ) vce (cluster  game)

tobit lnattendance shabbat i.dow i.venue i.teamhome i.which i.season ,ul ( lncapacity95perc ) vce (cluster  game)

tobit lnattendance shabbat  i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season ,ul ( lncapacity95perc ) vce (cluster  game)

****TABLE A4 IN THE PAPER****
estimates clear
eststo: tobit lnattendance shabbat    ,ul ( lncapacity95perc ) vce (cluster  game)
eststo: tobit lnattendance shabbat   ,ul ( lncapacity95perc ) vce (cluster  game)
eststo: tobit lnattendance shabbat i.dow i.venue i.teamhome i.which i.season ,ul ( lncapacity95perc ) vce (cluster  game)

eststo: tobit lnattendance shabbat i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season ,ul ( lncapacity95perc ) vce (cluster  game)

esttab, se keep(shabbat) indicate("Day of the week dummies = *.dow" "Venue dummies= *.venue" "Home-team dummies = *2.teamhome"  "Away-team dummies = *5.teamhome" "Season dummies= *.season" "Phase of the season dummies = *.which" "Additional controls= rainmm" ) coeflabel(shabbat "Shabbat") eqlab(none) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_rc ll, labels("Observations" "Censored Observations" "Log pseudolikelihood") fmt(%3.0f)) b(3) mlab(none)  nonotes addnotes() replace

*MULTI-CLUSTER SEs

tobit lnattendance shabbat    ,ul ( lncapacity95perc )
local betashabbat= _b[shabbat]
waldtest [lnattendance]shabbat, cluster(game teamhome)
di "doublecluster SE= `=`betashabbat'/`r(t)''"


tobit lnattendance shabbat i.dow i.venue i.teamhome i.which i.season ,ul ( lncapacity95perc ) 
local betashabbat= _b[shabbat]
waldtest [lnattendance]shabbat, cluster(game teamhome)
di "doublecluster SE= `=`betashabbat'/`r(t)''"

tobit lnattendance shabbat i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season ,ul ( lncapacity95perc ) 
local betashabbat= _b[shabbat]
waldtest [lnattendance]shabbat, cluster(game teamhome)
di "doublecluster SE= `=`betashabbat'/`r(t)''

*Table with different sub-samples
*Table 6 Preliminaries
*Games on most frequent days (Sunday, Monday and Saturday) without Tuesday, Wednesdays and Thursdays  (less than 4% of the data)
tobit lnattendance shabbat lncapacity i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if dow!=2 & dow!=3& dow!=4 ,ul ( lncapacity95perc ) vce (cluster  game)


*Games among non-top 5 teams (Maccabi Haifa, Maccabi TA, Hapoel TA, Hapoel BS, Beitar Jerusalem)
tabstat attendance if shabbat==1& home==1 & (teamhome!=1 & teamhome!=2 & teamhome!=11 & teamhome!=12 & teamhome!=27 & teamhome!=28 & teamhome!=33 &  teamhome!=34 & teamhome!=39 & teamhome!=40), by ( teamhome ) stat (mean sd min max n) // 338 observations over 15 teams
tabstat attendance if shabbat==0& home==1 & (teamhome!=1 & teamhome!=2 & teamhome!=11 & teamhome!=12 & teamhome!=27 & teamhome!=28 & teamhome!=33 &  teamhome!=34 & teamhome!=39 & teamhome!=40), by ( teamhome ) stat (mean sd min max n) // 704 observations over 15 teams

tobit lnattendance shabbat lncapacity i.dow i.venue i.teamhome mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if teamhome!=1 & teamhome!=2 & teamhome!=11 & teamhome!=12 & teamhome!=27 & teamhome!=28 & teamhome!=33 &  teamhome!=34 & teamhome!=39 & teamhome!=40 ,ul ( lncapacity95perc ) vce (cluster  game)

*Games only in regular season
tobit lnattendance shabbat lncapacity i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.season if which==2,ul ( lncapacity95perc ) vce (cluster  game)

****TABLE 6 IN THE PAPER****
estimates clear
eststo: tobit lnattendance shabbat lncapacity i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if dow!=2 & dow!=3& dow!=4 ,ul ( lncapacity95perc ) vce (cluster  game)

eststo: tobit lnattendance shabbat lncapacity i.dow i.venue i.teamhome mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if teamhome!=1 & teamhome!=2 & teamhome!=11 & teamhome!=12 & teamhome!=27 & teamhome!=28 & teamhome!=33 &  teamhome!=34 & teamhome!=39 & teamhome!=40 ,ul ( lncapacity95perc ) vce (cluster  game)


eststo: tobit lnattendance shabbat lncapacity i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.season if which==2,ul ( lncapacity95perc ) vce (cluster  game)

esttab, se keep(shabbat) indicate("Log of Stadium Capacity =lncapacity" "Day of the week dummies = *.dow" "Venue dummies= *.venue" "Home-team dummies = *2.teamhome"  "Away-team dummies = *5.teamhome" "Season dummies= *.season" "Phase of the season dummies = *.which" "Additional controls= rainmm" ) coeflabel(shabbat "Shabbat") eqlab(none) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_rc ll, labels("Observations" "Censored Observations" "Log pseudolikelihood") fmt(%3.0f)) b(3) mlab(none)  nonotes addnotes() replace


*Table with different sub-samples
*Table A5 Preliminaries
*Games on most frequent days (Sunday, Monday and Saturday) without Tuesday, Wednesdays and Thursdays  (less than 4% of the data)
tobit lnattendance shabbat i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if dow!=2 & dow!=3& dow!=4 ,ul ( lncapacity95perc ) vce (cluster  game)


*Games among non-top 5 teams (Maccabi Haifa, Maccabi TA, Hapoel TA, Hapoel BS, Beitar Jerusalem)
tabstat attendance if shabbat==1& home==1 & (teamhome!=1 & teamhome!=2 & teamhome!=11 & teamhome!=12 & teamhome!=27 & teamhome!=28 & teamhome!=33 &  teamhome!=34 & teamhome!=39 & teamhome!=40), by ( teamhome ) stat (mean sd min max n) // 338 observations over 15 teams
tabstat attendance if shabbat==0& home==1 & (teamhome!=1 & teamhome!=2 & teamhome!=11 & teamhome!=12 & teamhome!=27 & teamhome!=28 & teamhome!=33 &  teamhome!=34 & teamhome!=39 & teamhome!=40), by ( teamhome ) stat (mean sd min max n) // 704 observations over 15 teams

tobit lnattendance shabbat i.dow i.venue i.teamhome mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if teamhome!=1 & teamhome!=2 & teamhome!=11 & teamhome!=12 & teamhome!=27 & teamhome!=28 & teamhome!=33 &  teamhome!=34 & teamhome!=39 & teamhome!=40 ,ul ( lncapacity95perc ) vce (cluster  game)

*Games only in regular season
tobit lnattendance shabbat i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.season if which==2,ul ( lncapacity95perc ) vce (cluster  game)

****TABLE A5 IN THE PAPER****
estimates clear
eststo: tobit lnattendance shabbat i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if dow!=2 & dow!=3& dow!=4 ,ul ( lncapacity95perc ) vce (cluster  game)

eststo: tobit lnattendance shabbat  i.dow i.venue i.teamhome mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if teamhome!=1 & teamhome!=2 & teamhome!=11 & teamhome!=12 & teamhome!=27 & teamhome!=28 & teamhome!=33 &  teamhome!=34 & teamhome!=39 & teamhome!=40 ,ul ( lncapacity95perc ) vce (cluster  game)


eststo: tobit lnattendance shabbat i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.season if which==2,ul ( lncapacity95perc ) vce (cluster  game)

esttab, se keep(shabbat) indicate("Day of the week dummies = *.dow" "Venue dummies= *.venue" "Home-team dummies = *2.teamhome"  "Away-team dummies = *5.teamhome" "Season dummies= *.season" "Phase of the season dummies = *.which" "Additional controls= rainmm" ) coeflabel(shabbat "Shabbat") eqlab(none) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_rc ll, labels("Observations" "Censored Observations" "Log pseudolikelihood") fmt(%3.0f)) b(3) mlab(none)  nonotes addnotes() replace

*MULTI-CLUSTER SEs
tobit lnattendance shabbat i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if dow!=2 & dow!=3& dow!=4 ,ul ( lncapacity95perc )
local betashabbat= _b[shabbat]
waldtest [lnattendance]shabbat, cluster(game teamhome)
di "doublecluster SE= `=`betashabbat'/`r(t)''"

tobit lnattendance shabbat  i.dow i.venue i.teamhome mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if teamhome!=1 & teamhome!=2 & teamhome!=11 & teamhome!=12 & teamhome!=27 & teamhome!=28 & teamhome!=33 &  teamhome!=34 & teamhome!=39 & teamhome!=40 ,ul ( lncapacity95perc ) 
local betashabbat= _b[shabbat]
waldtest [lnattendance]shabbat, cluster(game teamhome)
di "doublecluster SE= `=`betashabbat'/`r(t)''"

tobit lnattendance shabbat i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.season if which==2,ul ( lncapacity95perc ) 
local betashabbat= _b[shabbat]
waldtest [lnattendance]shabbat, cluster(game teamhome)
di "doublecluster SE= `=`betashabbat'/`r(t)''"

*Table 7 Preliminaries
*Within Shabbat with time from end of shabbat in minutes

*All games on Saturday
tobit lnattendance shabbat lncapacity i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if dow==6 ,ul ( lncapacity95perc ) vce (cluster  game)

*Games after the end of shabbat 
tabstat attendance if home==1 &dow==6 & timefromshabbat>0 , by ( teamhome ) stat (mean sd min max n) // (n=572 for 20 teams) so T>20 on average per home team

tobit lnattendance shabbat timefromshabbat  lncapacity i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if dow==6 & timefromshabbat>0 ,ul ( lncapacity95perc ) vce (cluster  game)

*Games before the end of shabbat 
tabstat attendance if home==1 &dow==6 & timefromshabbat<0 , by ( teamhome ) stat (mean sd min max n) // (n=440 for 20 teams) so T>20 on average per home team

tobit lnattendance shabbat timefromshabbat  lncapacity i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if dow==6 & timefromshabbat<0 ,ul ( lncapacity95perc ) vce (cluster  game)


****TABLE 7 IN THE PAPER****
estimates clear
eststo: tobit lnattendance shabbat lncapacity i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if dow==6 ,ul ( lncapacity95perc ) vce (cluster  game)

eststo:tobit lnattendance shabbat timefromshabbat  lncapacity i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if dow==6 & timefromshabbat>0 ,ul ( lncapacity95perc ) vce (cluster  game)

eststo: tobit lnattendance shabbat timefromshabbat  lncapacity i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if dow==6 & timefromshabbat<0 ,ul ( lncapacity95perc ) vce (cluster  game)

esttab, replace se keep(shabbat timefromshabbat) indicate("Log of Stadium Capacity =lncapacity" "Day of the week dummies = *.dow" "Venue dummies= *.venue" "Home-team dummies = *2.teamhome"  "Away-team dummies = *5.teamhome" "Season dummies= *.season" "Phase of the season dummies = *.which" "Additional controls= rainmm" ) coeflabel(shabbat "Shabbat" timefromshabbat "Time to or from Shabbat") eqlab(none) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_rc ll, labels("Observations" "Censored Observations" "Log pseudolikelihood") fmt(%3.0f)) b(4) mlab(none)  nonotes addnotes() substitute( (.) " ") 


*Table A6 Preliminaries
*Within Shabbat with time from end of shabbat in minutes

*All games on Saturday
tobit lnattendance shabbat i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if dow==6 ,ul ( lncapacity95perc ) vce (cluster  game)

*Games after the end of shabbat 
tabstat attendance if home==1 &dow==6 & timefromshabbat>0 , by ( teamhome ) stat (mean sd min max n) // (n=572 for 20 teams) so T>20 on average per home team

tobit lnattendance shabbat timefromshabbat  i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if dow==6 & timefromshabbat>0 ,ul ( lncapacity95perc ) vce (cluster  game)

*Games before the end of shabbat 
tabstat attendance if home==1 &dow==6 & timefromshabbat<0 , by ( teamhome ) stat (mean sd min max n) // (n=440 for 20 teams) so T>20 on average per home team

tobit lnattendance shabbat timefromshabbat i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if dow==6 & timefromshabbat<0 ,ul ( lncapacity95perc ) vce (cluster  game)


****TABLE A6 IN THE PAPER****
estimates clear
eststo: tobit lnattendance shabbat i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if dow==6 ,ul ( lncapacity95perc ) vce (cluster  game)

eststo:tobit lnattendance shabbat timefromshabbat i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if dow==6 & timefromshabbat>0 ,ul ( lncapacity95perc ) vce (cluster  game)

eststo: tobit lnattendance shabbat timefromshabbat i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if dow==6 & timefromshabbat<0 ,ul ( lncapacity95perc ) vce (cluster  game)

esttab, replace se keep(shabbat timefromshabbat) indicate("Day of the week dummies = *.dow" "Venue dummies= *.venue" "Home-team dummies = *2.teamhome"  "Away-team dummies = *5.teamhome" "Season dummies= *.season" "Phase of the season dummies = *.which" "Additional controls= rainmm" ) coeflabel(shabbat "Shabbat" timefromshabbat "Time to or from Shabbat") eqlab(none) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_rc ll, labels("Observations" "Censored Observations" "Log pseudolikelihood") fmt(%3.0f)) b(4) mlab(none)  nonotes addnotes() substitute( (.) " ") 


tobit lnattendance shabbat i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if dow==6 ,ul ( lncapacity95perc ) 
local betashabbat= _b[shabbat]
waldtest [lnattendance]shabbat, cluster(game teamhome)
di "doublecluster SE= `=`betashabbat'/`r(t)''"

tobit lnattendance shabbat timefromshabbat i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if dow==6 & timefromshabbat>0 ,ul ( lncapacity95perc ) 
local betatimefromshabbat= _b[timefromshabbat]
waldtest [lnattendance]timefromshabbat, cluster(game teamhome)
di "doublecluster SE= `=`betatimefromshabbat'/`r(t)''"

tobit lnattendance shabbat timefromshabbat i.dow i.venue i.teamhome big5 mvalue rainmm temperature_2mC tempsq pos points distance probhome probhomesq matchday newcoach knowchamp knoweurope knowrelegated i.which i.season if dow==6 & timefromshabbat<0 ,ul ( lncapacity95perc ) 
local betatimefromshabbat= _b[timefromshabbat]
waldtest [lnattendance]timefromshabbat, cluster(game teamhome)
di "doublecluster SE= `=`betatimefromshabbat'/`r(t)''"

