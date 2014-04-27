library(reshape2)

if (!file.exists("data")) {
	dir.create("data")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
setInternet2(TRUE)
download.file(fileUrl, destfile = "./data/dataset.zip" , mode = "wb")
list.files("./data")
dateDownloaded <- date()
dateDownloaded

unzip("./data/dataset.zip", exdir = "./data/.")
setwd("./data/UCI HAR Dataset/")
activities <-read.table("activity_labels.txt")
features <-read.table("features.txt")

setwd("./test/")
stest<-read.table("subject_test.txt")
xtest<-read.table("X_test.txt")
ytest<-read.table("Y_test.txt")

setwd("../train/")
strain<-read.table("subject_train.txt")
xtrain<-read.table("X_train.txt")
ytrain<-read.table("Y_train.txt")

setwd("../../")
test<-cbind(stest, ytest, xtest)
train<-cbind(strain, ytrain, xtrain)
data<-rbind(test,train)
names(data)[1]<-"subject"
names(data)[2]<-"activity"
names(data)[3:563]<-features[,2]

meanCol<-grep("mean()", features[,2], fixed=TRUE)
stdCol<-grep("std()", features[,2], fixed=TRUE)
colSel<-c(-1, 0, meanCol, stdCol)
dataMerged<-data[,colSel+2]

library(reshape2)
dataMelt<-melt(dataMerged, c("subject","activity"))
dataTidy<-dcast(dataMelt, subject+activity~variable, mean)

write.table(dataMerged, file="dataMerged.csv", sep=",", append=FALSE)
write.table(dataTidy, file="dataTidy.csv", sep=",", append=FALSE)