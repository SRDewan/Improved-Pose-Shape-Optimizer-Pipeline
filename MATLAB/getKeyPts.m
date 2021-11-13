function [keyPts] = getKeyPts(seq, frm, id, keyptCtr, annotated)

keyPtsPath = '../parameters/result_KP.txt';
infoPath = '../parameters/infofile.txt';

if annotated
	keyPtsPath = '../parameters/annotated_KP.txt';
	infoPath = '../parameters/annInfofile.txt';
end

allKeyPts = load(keyPtsPath);
corrs = load(infoPath);
keyPts = zeros([size(seq, 2), keyptCtr * 3]);

for i = 1:size(corrs, 1)
	for j = 1:size(seq, 2)
		find = [seq(j), frm(j), id(j)];
		if corrs(i, 2:4) == find
			keyPts(j, :) = [allKeyPts(i, :)];
		end
	end
end
