#... Initialization ...

# Hamming(7,4) coding matrix
G <- c(1,1,0,1,
       1,0,1,1,
       1,0,0,0,
       0,1,1,1,
       0,1,0,0,
       0,0,1,0,
       0,0,0,1);
G <- t( array(G,dim=c(4,7)) );

# Hamming(7,4) parity matrix
H <- c(1,0,1,0,1,0,1,
       0,1,1,0,0,1,1,
       0,0,0,1,1,1,1);
H <- t( array(H,dim=c(7,3)) );

# Hamming(7,4) decoding matrix
R <- c(0,0,1,0,0,0,0,
       0,0,0,0,1,0,0,
       0,0,0,0,0,1,0,
       0,0,0,0,0,0,1);
R <- t( array(R,dim=c(7,4)) );

# vector with powers of 2
pow2 <- 2^c(0:2);

# initial 4-bit data block
d0 <- array(c(1,0,1,1),dim=c(4,1));


#... step 1: Encoding ...

# H(7,4) encoding
b1 <- (G %*% d0) %% 2;
# H(7,4) parity check
p1 <- (H %*% b1) %% 2;
# H(7,4) error flag, should be 0
e1 <- sum(p1);


#... step 2: insert a bit error ...

err <- array(c(0,0,0,0,1,0,0),dim=c(7,1));

# H(7,4) encoding
b2 <- (b1 + err) %% 2;
# H(7,4) parity check
p2 <- (H %*% b2) %% 2;
# H(7,4) error flag, should be 1
e2 <- sum(p2);

# H(7,4) error position in encoded
ee2 <- sum(p2*pow2);


#... step 3: fix error ...

# create fixed 4-bit encoded block
bc2 <- b2;
bc2[ee2] <- (bc2[ee2]+1) %% 2;
# H(7,4) parity check
pc2 <- (H %*% bc2) %% 2;
# H(7,4) error flag, should be 1
ec2 <- sum(pc2);


#... step 4: Decoding ...

# H(7,4) decoding
d3 <- (R %*% bc2) %% 2;
