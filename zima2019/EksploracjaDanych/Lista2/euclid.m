function [D] = euclid(X, Y)
  
  tic
  C = 2.*X'*Y;
  X = sum(X.^2);
  Y = sum(Y.^2)';
  D = (X.+Y)';
  D = D.-C;
  D = sqrt(D);
  toc
  
endfunction