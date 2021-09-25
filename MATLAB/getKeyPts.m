function [keyPts] = getKeyPts(seq, frm, id, keyptCtr)

allKeyPts = load('../parameters/result_KP.txt');
corrs = load('../parameters/infofile.txt');
keyPts = zeros([size(seq, 2), keyptCtr * 3]);

for i = 1:size(corrs, 1)
	for j = 1:size(seq, 2)
		find = [seq(j), frm(j), id(j)];
		if corrs(i, 2:4) == find
			keyPts(j, :) = [allKeyPts(i, :)];
		end
	end
end
