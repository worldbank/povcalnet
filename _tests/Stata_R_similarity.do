* Retrieve ONE country with default parameters

povcalnet, country("ALB")

* Retrieve MULTIPLE countries with default parameters

povcalnet, country("all") clear

povcalnet, country("ALB CHN") clear

* Change poverty line
povcalnet, country("ALB CHN") povline(10) clear

* Select specific years

povcalnet, country("ALB") year("2002 2012") clear

povcalnet, country("ALB") year("2002") clear

* Change coverage

povcalnet, country("all") coverage("urban") clear

povcalnet, country("all") coverage("rural") clear

* Aggregation
povcalnet, country("ALB CHN") aggregate clear

* Fill gaps when surveys are missing for specific year

povcalnet, country("ALB CHN") fillgaps 
povcalnet, country("ALB CHN") fillgaps coverage("national")

* PPP

povcalnet, country("ALB CHN") ppp(50 100) clear

