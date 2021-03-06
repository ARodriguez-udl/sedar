`aem` <-
function (build.binary, binary.mat, weight, rm.link0 = FALSE, print.binary.mat=FALSE) 
{
	if (missing(weight)) {
		weight <- 1
	}
	if(!is.numeric(weight)){
		stop("weight needs to be numeric")
	}
	
	if (missing(build.binary)) {
		if (is.matrix(binary.mat) == FALSE) {
			stop("binary.mat is not a matrix")
		}
		res.mat <- as.matrix(binary.mat)
	}
	else {
		res.mat <- build.binary[[1]]
		if (rm.link0) {
			link0 <- which(build.binary[[2]][, 1] == 0)
			res.mat <- res.mat[, -link0]
		}
	}
	nsite <- nrow(res.mat)
	res.mat <- t(t(res.mat) * weight)
	
	res.mat.ct <- apply(res.mat, 2, scale, scale = FALSE)
	val.vec <- svd(res.mat.ct, nu = (nsite - 1), nv = 0)
	val <- val.vec$d[1:(nsite - 1)]^2/(nsite - 1)
	
	lim<-10^{-12}
	val.sel<-which(val>=lim)
	vec.lim<-val.vec$u[,val.sel]
	val.lim<-val[val.sel]
	
	if(print.binary.mat){
		res<-list(val.lim,vec.lim,res.mat)
		names(res)<-c("values","vectors","mod.binary.mat")
	}else{
		res <- list(val, vec.lim)
		names(res) <- c("values", "vectors")
	}
	return(res)
}

