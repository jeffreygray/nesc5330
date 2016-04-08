function [fan_in_con,c_in_mat,w_in_mat] = CreateNetwork(ni, con, wstart, wdist, wlow, whigh)
%Function creates network. ni = neurons, con = connectivity, other parameters
%create the weight distribution. Fan_in_con is the input connections per neuron
%c_in_mat are what neurons input into each neuron. w_in_mat are the  weights
%corresponding to the connections in c_in_mat
	fan_in_con = zeros(ni,1);
	fan_in_con(:) = con*ni;
	c_in_mat = floor(rand(ni,ni*con)*ni); 
	w_in_mat = zeros(ni,ni*con);
	if(wdist == 0)
		w_in_mat(:,:) = wstart;
	else
		w_in_mat = rand(ni,ni*con)*(whigh-wlow)+wlow;
	end
end
