#a)
x = rand(100, 1);
y = rand(100, 1);
w = rand(100, 1);

length_x = sqrt(x'*x)
mean_x = sum(x.*w)/sum(w)
temp = x-y;
distance = sqrt(temp'*temp)
dot_prod = y'*x

#b)
X = rand(100, 1000);
y = rand(100, 1);
w = rand(100, 1);

N = sqrt(sum(X.^2, 1))
X_avg = (sum(X.*w)/sum(w))'
X_distance = sqrt(sum((X - y).^ 2, 1))'
X_dot = X.'*y