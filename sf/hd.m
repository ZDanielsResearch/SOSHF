function distance = hd(predicted, true)

predicted = double(predicted);
true = double(true);

Tplus = sum(true == 1);
Tminus = sum(true == 0);
Tlplus = sum(true & ~predicted);
Tlminus = sum(~true & ~predicted);
Trplus = sum(true & predicted);
Trminus = sum(~true & predicted);

distance = (sqrt(Tlplus ./ Tplus) - sqrt(Tlminus ./ Tminus)).^2 + (sqrt(Trplus ./ Tplus) - sqrt(Trminus ./ Tminus)).^2;

end