###############################################################
########## NODE ###############################################
###############################################################

# De percentielen
tiles <- c(.90, .95, .99)

# Basisverwerking
nodb_node_notes <- read.csv("NODB_NODE_NOTES.csv", header=TRUE,sep= ",",dec=".")
nodb_node_notes$timeStamp = nodb_node_notes$timeStamp - min(nodb_node_notes$timeStamp)
nodb_node_notes['Throughput'] <- NA
nodb_node_notes$Throughput <- ifelse(nodb_node_notes$elapsed ==0,(nodb_node_notes$bytes / 0.4) , (nodb_node_notes$bytes / nodb_node_notes$elapsed))

# Simpele plot 
#x <- nodb_node_notes$timeStamp
#y <- nodb_node_notes$Latency
#plot(x,y, main = "Latency van Node.js (basisgeval)", xlab = "Tijd (in ms)", ylab = "Latency (in ms)")
#regr <- lm(y ~ x)
#abline(regr, col = "red")
#per <- cor(y, x, method = "pearson")

# Opdelen in tijdsintervallen
nodb_node_notes_firs<- subset(nodb_node_notes, timeStamp > 0 & timeStamp < 5000)$Latency
nodb_node_notes_sec<- subset(nodb_node_notes, timeStamp > 5000 & timeStamp < 10000)$Latency
nodb_node_notes_low <- subset(nodb_node_notes, timeStamp > 10000 & timeStamp < 15000)$Latency
nodb_node_notes_med <- subset(nodb_node_notes, timeStamp > 15000 & timeStamp < 20000)$Latency
nodb_node_notes_max <- subset(nodb_node_notes, timeStamp > 20000 & timeStamp < 25000)$Latency

# Quantielen berekenen
firs <- quantile(nodb_node_notes_firs, tiles)
sec <- quantile(nodb_node_notes_sec, tiles)
low <- quantile(nodb_node_notes_low, tiles)
med <- quantile(nodb_node_notes_med, tiles)
perc <- quantile(nodb_node_notes_max, tiles)

# Data samenvoegen
list <- rbind(firs,sec,low,med,perc)
rownames(list) <- c("200", "400", "600", "800", "1000")
colnames(list) <- c("90%", "95%", "99%")

#############################
# Aantal requests per seconde
#############################
nrow(nodb_node_notes) / (max(nodb_node_notes$timeStamp)/1000)

###############################################################
########## GOLANG #############################################
###############################################################

# Basisverwerking
nodb_golang_notes <- read.csv("NODB_GOLANG_NOTES.csv", header=TRUE,sep= ",",dec=".")
nodb_golang_notes$timeStamp = nodb_golang_notes$timeStamp - min(nodb_golang_notes$timeStamp)
nodb_golang_notes['Throughput'] <- NA
nodb_golang_notes$Throughput <- ifelse(nodb_golang_notes$elapsed ==0,(nodb_golang_notes$bytes / 0.4) , (nodb_golang_notes$bytes / nodb_golang_notes$elapsed))

# Opdelen in tijdsintervallen
nodb_golang_notes_firs<- subset(nodb_golang_notes, timeStamp > 0 & timeStamp < 5000)$Latency
nodb_golang_notes_sec<- subset(nodb_golang_notes, timeStamp > 5000 & timeStamp < 10000)$Latency
nodb_golang_notes_low <- subset(nodb_golang_notes, timeStamp > 10000 & timeStamp < 15000)$Latency
nodb_golang_notes_med <- subset(nodb_golang_notes, timeStamp > 15000 & timeStamp < 20000)$Latency
nodb_golang_notes_max <- subset(nodb_golang_notes, timeStamp > 20000 & timeStamp < 25000)$Latency

firs <- quantile(nodb_golang_notes_firs, tiles)
sec <- quantile(nodb_golang_notes_sec, tiles)
low <- quantile(nodb_golang_notes_low, tiles)
med <- quantile(nodb_golang_notes_med, tiles)
perc <- quantile(nodb_golang_notes_max, tiles)

# Data samenvoegen
list2 <- rbind(firs,sec,low,med,perc)
rownames(list2) <- c("200", "400", "600", "800", "1000")
colnames(list2) <- c("90%", "95%", "99%")

#############################
# Aantal requests per seconde
#############################
nrow(nodb_golang_notes) / (max(nodb_golang_notes$timeStamp)/1000)


##########################
# Grafiek en tabel maken
##########################

# Configuratie plot
regions <- c("90% (Node)", "95% (Node)", "99% (Node)", "90% (Go)", "95% (Go)", "99% (Go)")
colors = c("darkred","red","pink", "darkblue", "blue", "lightblue")

par(xpd=FALSE)
barplot(rbind(t(list),t(list2)), xlab = "Aantal requests", ylab = "Latency (in ms)", col=colors, main = "Latency per aantal requests (basisgeval)", beside=T)
grid(nx=NA,ny=NULL,lty=2,col="black")
par(xpd=TRUE)
legend("topleft", legend=regions, cex = 0.6, fill = colors, title="Percentiel")
outtbl <- cbind(list,list2)
write.table(format(outtbl, digits=2, nsmall=0), "outTable.txt", quote=FALSE, eol="\\\\\n", sep=" & ")
