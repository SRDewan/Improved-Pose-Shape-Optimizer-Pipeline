function [groundTruth, objsInfo] = getObjsInfo(label_dir, seqs, frames, ids)

objsInfo = [];
groundTruth = [];

for idx = 1:size(seqs, 2)
    
    tracklet = readLabels(label_dir, seqs(idx));
    frameInfo = tracklet(frames(idx) + 1);
    info = [];
    truthInfo = [];

    for i = 1:size(frameInfo{1}, 2)
        if(frameInfo{1}(i).id == ids(idx))
            objData = frameInfo{1}(i);
            info = double([seqs(idx), objData.frame, objData.id]);
            truthInfo = info;
            
            info = [info [objData.x1, objData.y1, objData.x2, objData.y2, objData.ry]];
            truthInfo = [truthInfo objData.t];
        end
    end
    
    objsInfo = [objsInfo; info];
    groundTruth = [groundTruth; truthInfo];
end