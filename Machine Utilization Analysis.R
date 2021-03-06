#Machine Utilizations Project using Lists in R

#You have been engaged as a Data Science consultant by a coal terminal. They would
#like you to investigate one of their heavy machines - RL1

#You have been supplied one month worth of data for all of their machines. The
#dataset shows what percentage of capacity for each machine was idle (unused) in any
#given hour. You are required to deliver an R list with the following components:

# Character: Machine name
#Vector: (min, mean, max) utilisation for the month (excluding unknown hours)
#Logical: Has utilisation ever fallen below 90%? TRUE / FALSE
#Vector: All hours where utilisation is unknown (NA�s)
#Dataframe: For this machine
#Plot: For all machines
#-------------------------------------------------------------------------------------------

util <- read.csv(choose.files())

#data exploration
head(util, 12)
tail(util)

str(util)

util$Timestamp <- as.factor(util$Timestamp)
util$Machine <- as.factor(util$Machine)

#lets calculate the actual utilization and enter the reults in a new column

util$utilization <- 1 - util$Percent.Idle
head(util,10)

#taking care of timestamp column, as the date system is ambigious.

#converting the following in the Universal date time system using the POSIXct()

util$posix_time <- as.POSIXct(util$Timestamp, format= "%d/%m/%Y %H:%M") 
head(util,12)

#removing timestamp column
util$Timestamp <- NULL

#Re arranging the columns 
util <- util[,c(4,1,2,3)] 
head(util)

#machine name
RL1 <- util[util$Machine == "RL1",]
summary(RL1)
RL1$Machine <- factor(RL1$Machine)
summary(RL1)

#now as per the instruction for this project we need to construct the list

# Character: Machine name
#Vector: (min, mean, max) utilisation for the month (excluding unknown hours)
#Logical: Has utilisation ever fallen below 90%? TRUE / FALSE

#lets check the stats of the RL1 machine.

#Vector: (min, mean, max) utilisation for the month (excluding unknown hours)

stats_util_RL1 <- c(min(RL1$utilization, na.rm =T),
                    mean(RL1$utilization, na.rm =T),
                    max(RL1$utilization, na.rm =T))

stats_util_RL1

#Logical: Has utilisation ever fallen below 90%? TRUE / FALSE

util_under_90_flag <- length(which(RL1$utilization < 0.90)) > 0
util_under_90_flag

#now lets combine all these different data type results in a list.

list_rl1 <- list("RL1", stats_util_RL1, util_under_90_flag)
list_rl1

#naming the components of the list.

names(list_rl1) <- c("Machine", "Stats", "Low_threshhold")
list_rl1  

#Vector: All hours where utilisation is unknown (NA�s)

list_rl1$unknown_hours <- RL1[is.na(RL1$utilization),"posix_time"]
list_rl1

#Dataframe: For this machine(RL1)

list_rl1$df <- RL1

summary(list_rl1)

str(list_rl1)


#Plot: For all machines

library(ggplot2)

p <- ggplot(data =util)
p + geom_line(aes(x = posix_time, y= utilization, colour = Machine),
              size = 1.2) +
  facet_grid(Machine~.) + geom_hline(yintercept = 0.90, colour = "Gray", Size = 1.2,
                                     linetype = 3)

q <- p + geom_line(aes(x = posix_time, y= utilization, colour = Machine),
                   size = 1.2) +
  facet_grid(Machine~.) + geom_hline(yintercept = 0.90, colour = "Gray", Size = 1.2,
                                     linetype = 3)

#adding our plot q to our list list_rl1 with 6 components

list_rl1$plot <- q
list_rl1

#-------------------------------------------------------------------------------------------------