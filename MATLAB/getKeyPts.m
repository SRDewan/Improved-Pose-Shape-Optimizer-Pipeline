function [keyPts] = getKeyPts(seq, frm, id)

allKeyPts = load('../parameters/result_KP.txt');
corrs = load('../parameters/infofile.txt');
keyPts = [];

for i = 1:size(corrs, 1)
	for j = 1:size(seq, 2)
		find = [seq(j), frm(j), id(j)];
		if corrs(i, 2:4) == find
			keyPts = [keyPts; allKeyPts(i, :)];
		end
	end
end
