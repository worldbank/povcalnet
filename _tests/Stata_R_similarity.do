* Retrieve ONE country with default parameters

povcalnet, country("ALB") clear

* Retrieve MULTIPLE countries with default parameters

povcalnet, country("all") clear

povcalnet, country("ALB CHN") clear

* Change poverty line
povcalnet, country("ALB CHN") povline(10) clear

povcalnet, country("ALB CHN") povline(5 10) clear

* Select specific years

povcalnet, country("ALB") year("2002 2012") clear
povcalnet, country("ALB") year("2002 2020") clear  // just 2002
povcalnet, country("ALB") year("2020") clear       // error

povcalnet, country("ALB") year("2002") clear

* Change coverage

povcalnet, country("all") coverage("urban") clear

povcalnet, country("all") coverage("rural") clear

povcalnet, country("all") coverage("national") clear

povcalnet, country("all") coverage("rural national") clear

* Aggregation
povcalnet, country("ALB CHN") aggregate clear

* Fill gaps when surveys are missing for specific year

povcalnet, country("ALB CHN") fillgaps clear 
povcalnet, country("ALB CHN") fillgaps coverage("national")

* PPP

povcalnet, country("ALB CHN") ppp(50 100) clear



povcalnet cl, country("ALB CHN")       /*
            */	povline(1.9 2.0)          /*
            */  year(2002 2002)           /*
            */  ppp(40 30) clear

						