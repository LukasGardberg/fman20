function y = features2class(x, classification_data)
% classification function of ocr data x into one of 10 classes

pred = predict(classification_data, x');

if size(pred, 2) > 1
    [m, y] = max(pred);
else
    y = double(pred);
end


end