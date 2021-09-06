function edge_num = edgenum(img)
BW = edge(img,'canny',0.4);
index = find(BW~=0);
edge_num = length(index);
end