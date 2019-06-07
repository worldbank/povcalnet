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
cap noi povcalnet, country("ALB") year("2020") clear       // error

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
povcalnet, country("ALB CHN") fillgaps coverage("national") clear

* PPP

povcalnet, country("ALB CHN") ppp(50 100) clear


* Country level (one-on-one) request
povcalnet cl, country("ALB CHN")       /*
            */	povline(1.9 2.0)          /*
            */  year("all")           /*
            */  ppp(40 30) clear

						
povcalnet cl, country("DOL DOM")           /*  get info only for DOM
            */	coverage("national")      /*
            */  year(2002)             /*
            */  povline(10) clear

						
povcalnet cl, country("COL DOM")           /*  get info only both
            */	coverage("national")      /*
            */  year(all)             /*
            */  povline(4) clear

						
povcalnet cl, country("COL DOM")            /*  
            */	coverage("urban national")  /*
            */  year(all)                   /*
            */  povline(4) clear
