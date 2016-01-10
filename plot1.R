### 
### Download Data set
### Param boolean to download zip or not
###
plot1Setup <- function(download)
{
  #download dataset if requested
  if (download==TRUE)
  {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip","hpc.zip",mode="wb")
  }
  
  #create data directory
  if (!file.exists("datadir"))
  {
    dir.create("datadir")
  }
  
  #unzip dataset
  unzip("hpc.zip",exdir="./datadir")
}

###
### Read data and subset
###
plot1ReadData <- function()
{
  dataset <- read.csv("./datadir/household_power_consumption.txt", sep = ";", stringsAsFactors = FALSE)
  
  #convert to date to date type
  dataset$Date <- as.Date(dataset$Date,"%d/%m/%Y")
  
  filter <- dataset$Date==as.Date("01/02/2007","%d/%m/%Y") | dataset$Date==as.Date("02/02/2007","%d/%m/%Y")
  
  #subset
  dataset <- dataset[filter,]
  
  #set numeric type
  dataset$Global_active_power <- as.numeric(dataset$Global_active_power)
  
  return (dataset)
}

###
### Create plot and save to .png
###
plot1Render <- function(dataset)
{
  #Open gfx device
  png("plot1.png", width=480, height=480)
  
  #Plot
  hist(dataset$Global_active_power,col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)")
  
  #Close device
  dev.off()
}

###
### Main routine
###
plot1Run <- function(download = FALSE)
{
  #Prep Data
  plot1Setup(download)
  
  #Load data
  dataset <- plot1ReadData()
  
  #Render
  plot1Render(dataset)
}