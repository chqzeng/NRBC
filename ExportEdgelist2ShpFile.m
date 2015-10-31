
function ExportEdgelist2ShpFile(edgelist,xOffset,yOffset,pixelSpace,OutFileName)
%%edgelist is the output of edges in cell format from MatlabFn
%%this file is to write polyline from Matlab into ARcgis as SHPFILE.
% for I = 1:Nedge
%    line(edgelist{I}(:,2), edgelist{I}(:,1),  'LineWidth', lw, 'Color', col(I,:));
% end	
% Meanshift_Pts(1,:)=Meanshift_Pts(1,:)*2+704344;
% Meanshift_Pts(2,:)=Meanshift_Pts(2,:)*-2+5660810;
%
%-------------------Copyright and citiation--------------------------------
%  This code is published under GNU GENERAL PUBLIC LICENSE v3, more details about this license please read: [here] ( https://github.com/chqzeng/NRBC/blob/master/LICENSE)
%
% Please cite this work as:  
% Zeng, C.; Bird, S.; Luce, J.J.; Wang, J. A Natural-Rule-Based-Connection (NRBC) Method for River Network Extraction from High-Resolution Imagery. Remote Sens. 2015, 7, 14055-14078.
% open accessed  of this paper: [Here] (http://www.mdpi.com/2072-4292/7/10/14055).
% 
% Contact:  Chuiqing Zeng:   chqzeng@gmail.com  
%------------------------------------------------------------------------------     

nLength= length(edgelist);  %the number of edge objects

[Tracks(1:nLength).Geometry] = deal('Line');  %output shapefile type
trackType ='rh'; % 'rh';   %feature type: rh  -->rhumb line
unit='meter';
[Tracks.Type] = deal(trackType);

%iterate to save construct the polyline and read to save.
%figure; hold on;
for idx = 1:nLength
    
     if isempty(edgelist{idx})
         continue
     end
     
    %pointList=[xOffset+pixelSpace.*edgelist{idx}(:,1); NaN,yOffset+pixelSpace.*edgelist{idx}(:,2); NaN];
    Tracks(idx).X=[xOffset+pixelSpace.*edgelist{idx}(:,2);NaN];
    Tracks(idx).Y=[yOffset-pixelSpace.*edgelist{idx}(:,1);NaN];
    % pointList=[tempY,tempX]; 
    %[Tracks(idx).X Tracks(idx).Y] = track(trackType, pointList,unit);  %radius or degree

%    Tracks(idx).X =xOffset+pixelSpace.*edgelist{idx}(:,2); 
 %   Tracks(idx).Y=yOffset+pixelSpace.*edgelist{idx}(:,1); 
    %plot(pointList(:,1),pointList(:,2))
    
    %mapshow(x,y,'DisplayType','line')
end
%hold off;

shapewrite(Tracks, OutFileName); %'Bow_river_CentralLine_ske'

end
