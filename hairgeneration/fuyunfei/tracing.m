function hair = tracing(seed, orientation, confidence, mask)
 msg = ('tracing hair growth...');
 disp(msg)
 w_low = 0.05;
 step = 0.75;
 max_theta = pi/6;

for i = 1:length(seed)
    y = real(seed(i));
    x = imag(seed(i));
    strand_f{i} = search_forward(y,x,orientation,confidence,w_low,step,max_theta,mask);
    strand_b{i} = search_back(y,x,orientation,confidence,w_low,step,max_theta,mask);
    hair{i} = [flip(strand_b{i});strand_f{i}];
end
hair = hair(~cellfun(@isempty,hair));

