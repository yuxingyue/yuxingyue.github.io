set more off
clear all
cd "E:\微观计量\作业4\"
use "E:\微观计量\作业4\cgss2015_14.dta", clear
//被解释变量

gen life_satisfied = .
replace life_satisfied = 1 if a36>=4
replace life_satisfied = 0 if a36<4

label define life 1"幸福" 2"不幸福" 
label values life_satisfied life
//解释变量
//一、个人板块
//1.性别 gender
replace a2 =0 if a2==2
replace a2 = 1 if a2==1
label define a2 1"男" 0"女"
label values a2 a2
rename a2 gender
//2.年龄 age
gen age = 2015-a301
//3.个人全年总收入 income
replace a8a= . if a8a==9999997&9999998&9999999
rename a8a income
//4.个人教育程度最高 edu
rename a7a edu
replace edu=1 if edu==1
replace edu=2 if edu==2
replace edu=3 if edu==3
replace edu=4 if edu==4
replace edu=5 if edu==5|edu==6|edu==7|edu==8
replace edu=6 if edu==9
replace edu=7 if edu==10
replace edu=8 if edu==11
replace edu=9 if edu==12
replace edu=10 if edu==13
replace edu=. if edu==.|edu<0
label define edu_ 1"没有教育" 2"私塾、扫盲班" 3"小学" 4"初中"5"高中"6"大学专科（成人）"7"大学专科（正规）"8"大学本科（成人）"9"大学本科（正规）"10"研究生以上"
label values edu edu_
//5.政治面貌 party
replace a10=. if a10==-8
label define poli_status 1"群众" 2"共青团员"3"民主党派"4"共产党员"
label values a10 poli_status
rename a10 party
//6.个人身体健康状况 health
replace a15=. if a10==-8
label define health_condition 1"很不健康" 2"比较不健康"3"一般"4"比较健康"5"很健康"
label values a15 health_condition
rename a15 health
//7.户口 
label define hukou_residence 1"本乡（镇、街道）" 2"本县（市、区）其他乡（镇、街道）"3"本区/县/县级市以外"4"户口待定"
label values a21 hukou_residence
rename a21 hukou_residence
//8.宗教信仰
//9.参加宗教信仰的频率
rename a6 belief
replace belief=. if belief==-8 
replace belief=1 if belief==1
replace belief=2 if belief==2|belief==3|belief==4
replace belief=3 if belief==5|belief==6
replace belief=4 if belief==7|belief==8|belief==9
label define belief 1"从来没有参加过" 2"一年几次" 3"一月几次" 4"一周几次"
label values belief belief
//10.心理健康状况
replace a17=. if a17==-8
rename a17 mental
label define mental_condition 1"总是" 2"经常" 3"有时" 4"很少"5"从不"
label values mental mental_condition
//11.对互联网（手机）使用情况
replace a285=. if a285==-8
rename a285 inter_using
label define internet_using  1"从不" 2"很少" 3"有时" 4"经常"5"非常频繁"
label values inter_using internet_using
//12.学习充电频率
replace a311=. if a311==-8
rename a311 learning
label define learning  1"从不" 2"很少" 3"有时" 4"经常"5"非常频繁"
label values learning learning
//13.休息放松频率
replace a312=. if a312<0
rename a312 relaxing
label define relaxing  1"从不" 2"很少" 3"有时" 4"经常"5"非常频繁"
label values relaxing relaxing
//14.社交/串门频率
replace a313=. if a313==-8
rename a313 social
label define social 1"从不" 2"很少" 3"有时" 4"经常"5"非常频繁"
label values social social
//15.度假频率
replace a32=. if a32==-8
rename a32 holiday
label define holiday 1"从不" 2"1-5个晚上" 3"6-10个晚上" 4"11-20个晚上"5"22-30个晚上"6"超过30个晚上"
label values holiday holiday
//16.工作单位类型
rename a59j job_type
replace job_type=. if job_type==-8
replace job_type=. if job_type==-8
label define job_type 1"党政机关" 2"企业" 3"事业单位" 4"社会团体、居/村委会"5"无单位/自雇（包括个体户）"6"军队"7"其他"
label values job_type job_type
//17.工作性质
replace a59e=. if a59e==-8
replace a59e =0 if a59e==2
replace a59e = 1 if a59e==1
label define job_nature 1"全职工作" 0"非全职工作"
label values a59e job_nature
rename a59e job_nature
//33.是否结婚/同居
gen married = 0 
replace married = 1 if a69 == 2|a69== 3|a69 == 4
//19.社会经济地位
rename b1 social_ecolevel
//20.收入是否合理
gen income_proper = 0
replace income_proper = 1 if b5 == 1|b5==2
//21.社交程度
rename b12 soci_communication
//22.工作待遇是否合理
rename c105 jobduty_treat
rename c104 jobcomple_treat
//23.心理状况
rename c161 peacemood_frequency
rename c162 energetic_frequency
rename c17 exhaust_frequency
rename c18 cannot_bear_frequency
//24.换工作个数
rename c20 jobnumber
//25.教育是否与工作匹配
gen edu_match = 0
replace edu_match = 1 if c22 ==1
//26.技能与工作匹配
gen skill_match = 0
replace skill_match = 1 if c23 == 1
//27.做家务时间
rename c241 usual_housework_time
rename c261 week_housework_time
//28.通勤时间
rename c281 commutetime

//二、家庭层面
//29.家庭收入
replace a62 = . if a62 <0
rename a62 hh_totalincome
//30.家庭房产套数
rename a65 hh_housenumber
replace hh_housenumber = . if hh_housenumber<0
//31.是否有车
replace a66 = 0 if a66 == 2
label define a66 1"有" 0 "没有"
label values a66 a66
rename a66 hh_car
//32.子女数
rename a681 sonnumber
rename a682 daughternumber
egen childnumber = sum(sonnumber+daughternumber)

//34.配偶年龄
gen spouseage = 2015-a71a
//35.配偶受教育程度
gen spouseedu = 1 if a72 == 1
replace spouseedu = 2 if a72 == 2
replace spouseedu = 3 if a72 == 3
replace spouseedu = 4 if a72 == 4 
replace spouseedu = 5 if a72 == 5|a72==6|a72==7|a72 == 8
replace spouseedu = 6 if a72 == 9
replace spouseedu = 7 if a72 ==10
replace spouseedu = 8 if a72 == 11
replace spouseedu = 9 if a72 == 12
replace spouseedu = 10 if a72 == 13
replace spouseedu = . if a72==.|a72<0
label define spouseedu_ 1"没受教育" 2"私塾、扫盲班" 3"小学" 4"初中" 5"高中学历"/*
*/ 6"大学专科（成人）" 7 "大学专科（正规）" 8"大学本科（成人）" 9"大学本科（正规）"/*
*/ 10"研究生以上"
label values spouseedu spouseedu_ 
//37.配偶政治面貌(党员/非党员）
gen spouseparty = 1 if a73 == 4
replace spouseparty = 0 if a73 == 1|a73 == 2|a73 == 3
//38.配偶收入
replace a75a = . if a75a<0
rename a75a spouseincome
//39.配偶周工作时间
gen spouse_weekhour = a76a
replace spouse_weekhour = . if a76a<0
//40.配偶工作性质（全职/非全职）
replace a85 = 0 if a85 == 2
label define a85 1"全职工作" 0 "非全职工作"
label values a85 a85
replace a85 = . if a85<0
rename a85 spousejob_nature
//44.父亲受教育程度
gen fatheredu = 1 if a89b == 1
replace fatheredu = 2 if a89b == 2
replace fatheredu = 3 if a89b == 3
replace fatheredu = 4 if a89b == 4 
replace fatheredu = 5 if a89b == 5|a89b ==6|a89b ==7|a89b == 8
replace fatheredu = 6 if a89b == 9
replace fatheredu = 7 if a89b ==10
replace fatheredu = 8 if a89b == 11
replace fatheredu = 9 if a89b == 12
replace fatheredu = 10 if a89b == 13
replace fatheredu = . if a89b ==.|a89b <0
label define fatheredu_ 1"没受教育" 2"私塾、扫盲班" 3"小学" 4"初中" 5"高中学历"/*
*/ 6"大学专科（成人）" 7 "大学专科（正规）" 8"大学本科（成人）" 9"大学本科（正规）"/*
*/ 10"研究生以上"
label values fatheredu fatheredu_
// 45.母亲受教育程度
gen motheredu = 1 if a90b == 1
replace motheredu = 2 if a90b == 2
replace motheredu = 3 if a90b == 3
replace motheredu = 4 if a90b == 4 
replace motheredu = 5 if a90b == 5|a89b ==6|a89b ==7|a89b == 8
replace motheredu = 6 if a90b == 9
replace motheredu = 7 if a90b ==10
replace motheredu = 8 if a90b == 11
replace motheredu = 9 if a90b == 12
replace motheredu = 10 if a90b == 13
replace motheredu = . if a90b ==.|a90b <0
label define motheredu_ 1"没受教育" 2"私塾、扫盲班" 3"小学" 4"初中" 5"高中学历"/*
*/ 6"大学专科（成人）" 7 "大学专科（正规）" 8"大学本科（成人）" 9"大学本科（正规）"/*
*/ 10"研究生以上"
label values motheredu motheredu_
//46.14岁父亲就业状况（无固定工作/固定工作）
gen father_job14 = 0
replace father_job14 = 1 if a89d==1|a89d==2|a89d==3|a89d==4|a89d==6/*
*/ |a89d==9|a89d==10
label define fatherjob 1"有固定工作"0"无固定工作"
label values father_job14 fatherjob


//三、公共服务满意度
rename b161 comedu_degree
rename b162 commedi_degree
rename b163 housesupport_degree
rename b164 commanage_degree
rename b165 laboremploy_degree
rename b166 sociasupport_degree
rename b169 basic_manufac_degree
//四社会态度
//社会公平
rename a35 social_justice
//自我阶层
rename a431 self_level
//未来预期
rename a433 forward_selflevel
//五政治参与
//是否参与选举
gen politic_join = 0 
replace politic_join = 1 if a44 == 1

keep id life_satisfied  gender age income edu party health hukou_residence belief mental/*
*/ inter_using learning relaxing social holiday job_type job_nature married /*
*/ social_ecolevel income_proper jobduty_treat jobcomple_treat peacemood_frequency/*
*/ energetic_frequency exhaust_frequency cannot_bear_frequency jobnumber edu_match/*
*/ skill_match usual_housework_time week_housework_time commutetime hh_totalincome/*
*/ hh_housenumber hh_car childnumber spouseage spouseedu spouseparty spouseincome/*
*/ spouse_weekhour spousejob_nature fatheredu motheredu father_job14 comedu_degree/*
*/ commedi_degree housesupport_degree commanage_degree laboremploy_degree sociasupport_degree/*
*/ basic_manufac_degree social_justice self_level forward_selflevel politic_join

order life_satisfied

//回归
set more off
global y_s life_satisfied
global x_s gender age income edu party health hukou_residence belief mental/*
*/ inter_using learning relaxing social holiday job_type job_nature married /*
*/ social_ecolevel income_proper jobduty_treat jobcomple_treat peacemood_frequency/*
*/ energetic_frequency exhaust_frequency cannot_bear_frequency jobnumber edu_match/*
*/ skill_match usual_housework_time week_housework_time commutetime hh_totalincome/*
*/ hh_housenumber hh_car childnumber spouseage spouseedu spouseparty spouseincome/*
*/ spouse_weekhour spousejob_nature fatheredu motheredu father_job14 comedu_degree/*
*/ commedi_degree housesupport_degree commanage_degree laboremploy_degree sociasupport_degree/*
*/ basic_manufac_degree social_justice self_level forward_selflevel politic_join
 logout, save(lasso.doc) word dec(3) replace:lasso2 $y_s $x_s 
//logit回归

asdoc logit $y_s $x_s, save(logit.doc)

//lasso
logout, save(lasso.xml) excel dec(3) replace:lasso2 $y_s $x_s 
lasso2 $y_s $x_s , plotpath(lambda)  
//k_not cross_validation
asdoc cvlasso $y_s $x_s, lopt seed(123) save(cvlasso.doc)
//elastic net
logout,save(elasticnet.xml)excel dec(3) replace: lasso2 $y_s $x_s,alpha(0.1) 







