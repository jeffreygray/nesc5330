function [fan_in_con,c_in_mat,w_in_mat] = CreateNetwork(ni, con, wstart, wdist, wlow, whigh)
%Function creates network. ni = neurons, con = connectivity, other parameters
%create the weight distribution. Fan_in_con is the input connections per neuron
%c_in_mat are what neurons input into each neuron. w_in_mat are the  weights
%corresponding to the connections in c_in_mat

	fan_in_con = zeros(ni,1);
	fan_in_con(:) = con*ni;

	rng(1);
	% Generate w_in_mat
	w_in_mat = zeros(ni,ni*con);
	if(wdist == 0)
		w_in_mat(:,:) = wstart;
	else
		w_in_mat = rand(ni,ni*con)*(whigh-wlow)+wlow;
	end
	rng(1);

	% Generate c_in_mat
	c_in_mat = zeros(ni, ni*con);
	for i = 1:ni
		c_in_mat(i, :) = randsample(1:ni, ni*con)-1;
	end

	[c_in_mat, idx] = sort(c_in_mat, 2);
	for i = 1:ni
		w_in_mat(i, :) = w_in_mat(i, idx(i, :));
	end
end
