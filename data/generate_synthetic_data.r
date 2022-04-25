#
# generates synthetic point cloud of noisy lines
#
# Author: Christoph Dalitz
#         Hochschule Niederrhein, Krefeld, Germany
# Date:   2017-03-01
#

#
# Hint: the plots from scatter3D have margins
#       these can be removed with http://croppdf.com/
#

library(plot3D)

outfiles <- c("synthetic_a.dat", "synthetic_b.dat", "synthetic_c.dat")


a <- rbind(c(2,2,2), c(-1,-3,-1), c(0,3,3), c(1,0,-1))
b <- rbind(c(1,1,1), c(0,1,1), c(1,1,1), c(-1,1,-1))
b <- t(apply(b, 1, function(x)(x/sqrt(x%*%x))))  # normalize to length one
len <- c(8,5,6,10)
n <- c(50, 30, 60, 60)

line.points <- function(a, b, len, n, sigma=0.1) {
    t <- runif(n, min=-len/2, max=len/2)
    x <- data.frame(x1=(a[1] + b[1]*t + rnorm(n, sd=sigma)),
                    x2=(a[2] + b[2]*t + rnorm(n, sd=sigma)),
                    x3=(a[3] + b[3]*t + rnorm(n, sd=sigma)))
}

#cat("# line 1\n", file=outfile, append=TRUE)
#write.table(x, file=outfile, append=TRUE, sep=",", row.names=FALSE, col.names=FALSE)

# generate line data
x <- data.frame()
for (i in 1:nrow(a)) {
    x <- rbind(x, line.points(a[i,], b[i,], len[i], n[i]))
}

# write to file
for (outfile in outfiles) {
    cat("#\n# synthetically generated point cloud with four lines\n#\n", file=outfile)
    offset <- 0
    for (i in 1:nrow(a)) {
        cat(sprintf("# line %i\n", i), file=outfile, append=TRUE)
        write.table(x[(1+offset):(n[i]+offset),], file=outfile, append=TRUE, sep=",", row.names=FALSE, col.names=FALSE)
        offset <- offset + n[i]
    }
}

# plot data
scatter3D(x$x1, x$x2, x$x3, col="black")
for (i in 1:nrow(a)) {
    endpoints <- rbind(a[i,]-(len[i]/2)*b[i,], a[i,]+(len[i]/2)*b[i,])
    lines3D(endpoints[,1], endpoints[,2], endpoints[,3], col="red", add=TRUE)
}
dev.copy(pdf, "synthetic_a.pdf")
dev.off()

# compute bounding box
endpoints <- a - sweep(b, MARGIN=1, len/2, '*')
bb.min <- apply(endpoints, MARGIN=2, FUN=min)
endpoints <- a + sweep(b, MARGIN=1, len/2, '*')
bb.max <- apply(endpoints, MARGIN=2, FUN=max)

# add 50 noise points
n.noise <- 50
noise <- cbind(runif(n.noise, bb.min[1], bb.max[1]),
               runif(n.noise, bb.min[2], bb.max[2]),
               runif(n.noise, bb.min[3], bb.max[3]))
points3D(noise[,1], noise[,2], noise[,3], col="black", add=TRUE)
dev.copy(pdf, "synthetic_b.pdf")
dev.off()
cat(sprintf("# noise\n", i), file=outfiles[2], append=TRUE)
write.table(noise, file=outfiles[2], append=TRUE, sep=",", row.names=FALSE, col.names=FALSE)

# add 200 noise points
n.noise <- 200
noise <- cbind(runif(n.noise, bb.min[1], bb.max[1]),
               runif(n.noise, bb.min[2], bb.max[2]),
               runif(n.noise, bb.min[3], bb.max[3]))
points3D(noise[,1], noise[,2], noise[,3], col="black", add=TRUE)
dev.copy(pdf, "synthetic_c.pdf")
dev.off()
cat(sprintf("# noise\n", i), file=outfiles[3], append=TRUE)
write.table(noise, file=outfiles[3], append=TRUE, sep=",", row.names=FALSE, col.names=FALSE)
