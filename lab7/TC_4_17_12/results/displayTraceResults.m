function displayTraceResults

Me = 40;

file = 'surface.mat';
if( exist(file) == 2 )
    load(file);
    figure;
    imagesc(Totalsurface);
	colormap(noaa_colorgradient);
    caxis( [ 0 0.2] );
    colorbar;
	xlabel('time, deltaT = 20ms');
	ylabel('trials');
    title('Training Activity Surface ');
	print('TrainSurf.png', '-dpng');
	close;

	firstAct = Totalsurface(1,:);
	figure;
	plot(firstAct);
	axis([0, length(firstAct), 0, 0.2]);
    title('First Trial Activity Plot ');
	print('FirstAct.png', '-dpng');
	close;
    
end %if exist

file = 'USactivity.mat';
if( exist(file) == 2 )
	load(file);
    figure;
    imagesc(USactivity);
    caxis( [ 0 0.5] );
    colorbar;
    title('Training US Activity Surface ');
	print('UStrainSurf.png', '-dpng');
	close;    
end %if exist

file = 'testing_151.mat';
if( exist(file) == 2 )
	load(file);
    figure;
	ZRT = SpyTraceReorderedThinned(Me, 2*Me, Z, Z, 0);
	spy(ZRT(:, :));
	title('Testing Spy Trial 151');
	print(['TestSpy.png'], '-dpng');
	close;
    
end %if exist    

file = 'K0history.mat';    
if( exist(file) == 2 )
	load(file);
    Ks = k0tracker;
    figure;
	plot(Ks);
	axis([0 length(Ks) min(Ks)*.9 max(Ks)*1.09]);
    title('K0 History ');
	print('K0history.png', '-dpng');
	close;
end %if exist

file = 'finalweights.mat';
if( exist(file) == 2)
	figure;
	load(file);
	[a,b] = size(wInMatrix);
	W = reshape(wInMatrix, a*b,1);
	[hh,xx] = hist(W, [-0.025:0.05:1.025]);
	bar(xx,hh);
	axis([ -0.1 1.1 0 max(hh)*1.1]);
    title('Histogram of the weights ')
	print('Weights.png', '-dpng');
	close;
end


end%function