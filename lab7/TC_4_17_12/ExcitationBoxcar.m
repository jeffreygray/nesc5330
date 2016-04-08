function y = ExcitationBoxcar(excite,inhibit,inputlist,KFF)

y = (sum(excite))/(sum(excite) + sum(inhibit) + sum(inputlist) * KFF);

end
