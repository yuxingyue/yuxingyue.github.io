clear all
program boost_plugin, plugin using("C:\Users\derong\Documents\boost64.dll")
set memory 100m
set more off
 
//generate data
set obs 2000 
set seed 345678  
gen x1= uniform()
gen x2= uniform()
gen x3= uniform()
gen x4= uniform() 
local SNR=4  /* signal to noise ratio*/
gen y= 5+(x1-0.5)^2 + 2*(x2^(-.5)) +x3
qui sum y
local sigma = sqrt(r(Var)/`SNR')
replace y=y+ uniform()* `sigma'
* Explore various numbers of interactions 
gen bestiter=.
gen Rsquared=.
gen myinter=.
local i=0
foreach inter of numlist 1/5  {
	local i=`i'+1
        replace myinter= `inter' in `i'
	boost y x1 x2 x3 x4, distribution(normal) train(0.5) bag(0.5) maxiter(4000) interaction(`inter') shrink(0.01)  seed(1)
	replace Rsquared=e(test_R2) in `i'
	replace bestiter=e(bestiter) in `i'

}
rename myinter interaction
label var Rsquared " R-squared (on a test dataset)"
twoway connected Rsquared inter, xtitle("Number of interactions")  
graph save "normal_Rsquared", replace


***************************************************************************
boost y x1 x2 x3 x4, distribution(normal) train(0.5) bag(0.5) maxiter(4000) interaction(1) shrink(0.01) pred("boost_pred") influence  seed(1)
global trainn=e(trainn)
profiler off 
profiler report 


***************************************************************************
*compare the R^2 of boosted (with appropriate number of iterations ) and linear models 
regress y x1 x2 x3 x4 in 1/$trainn
predict regress_pred

* compute Rsquared on test data - lin regression
gen regress_eps=y-regress_pred 
gen regress_eps2= regress_eps*regress_eps 
replace regress_eps2=0 if _n<=$trainn  
gen regress_ss=sum(regress_eps2)
local mse=regress_ss[_N] / (_N-$trainn)
sum y if _n>$trainn
local var=r(Var)
local regress_r2= (`var'-`mse')/`var'
di "Linear regression : mse=" `mse' " var=" `var'  " regress r2="  `regress_r2'

* compute Rsquared on test data - boosting
* This yields the same number as e(test_R2) after the boost command
gen boost_eps=y-boost_pred 
gen boost_eps2= boost_eps*boost_eps 
replace boost_eps2=0 if _n<=$trainn  
gen boost_ss=sum(boost_eps2)
local mse=boost_ss[_N] / (_N-$trainn)
sum y if _n>$trainn
local var=r(Var)
local boost_r2= (`var'-`mse')/`var'
di "Boosting:  mse=" `mse' " var=" `var'  " boost r2="  `boost_r2'



***************************************************************************
* Calibration plot
* scatter plot of predicted versus actual values of y
* a straight line would indicate a perfect fit
drop if _n>$trainn
capture drop straight 
capture drop pred
capture drop method 
local count=_N
preserve
expand 2
gen pred=regress_pred
replace pred=boost_pred if _n>`count'
gen method="Linear Regression"
replace method="Boosting" if _n>`count'
label var method "Regression Method"
gen straight=.
replace straight=y

twoway (scatter  pred  y) (lfit straight y) , by(method, legend(off))  xtitle("Actual y Values")  ytitle("Fitted y Values") xsize(8) ysize(4)  ylab(0 10 20 to 50) xlab(0 10 20 to 50) 
graph save "normal_calibration" , replace 
restore

