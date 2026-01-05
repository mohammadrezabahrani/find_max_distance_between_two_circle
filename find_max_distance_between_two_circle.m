clc;
clear;
close all;

main_im=imread('pic_3.png');

im=main_im;

[M,N,Z]=size(im);

im2=logical(zeros(M,N));

for i=1:M
    for j=1:N
        if(im(i,j,1)>0 || im(i,j,2)>0 || im(i,j,3)>0 )
            im2(i,j)=1;
        end
    end
end

% array that save row1 and col1 and row2 and col2 and distance between two
% circle
index=1;
circle_details_array=zeros(1,9);

row1=1;
tag=true;
while tag

    
        
    color_tag=false;
    
    %find first color pixel------------------
    for i=row1:M
        for j=1:N
            if(im2(i,j)==1)
                red=im(i,j,1);
                green=im(i,j,2);
                blue=im(i,j,3);
                row1=i;
                col1=j;
                color_tag=true;
                break;
            end
        end
        if color_tag
            break;
        end  
    end
    
    if color_tag
        
        
        boundary1=bwtraceboundary(im2,[row1,col1],'N',8,inf);
        min_row1=row1;
        max_row1=max(boundary1(:,1));
        min_col1=min(boundary1(:,2));
        max_col1=max(boundary1(:,2));
        im2(min_row1:max_row1,min_col1:max_col1)=0;
        im(min_row1:max_row1,min_col1:max_col1,:)=0;   
 
        %find second circle-------------------------
        temp_tag=false;
        for i=row1:M
            for j=1:N
                if(im(i,j,1)==red && im(i,j,2)==green && im(i,j,3)==blue  )
                    row2=i;
                    col2=j;
                    temp_tag=true;
                    break;
                end
            end
            if temp_tag
                break;
            end  
        end
        
        boundary2=bwtraceboundary(im2,[row2,col2],'N',8,inf);
        min_row2=row2;
        max_row2=max(boundary2(:,1));
        min_col2=min(boundary2(:,2));
        max_col2=max(boundary2(:,2));
        im2(min_row2:max_row2,min_col2:max_col2)=0;
        im(min_row2:max_row2,min_col2:max_col2,:)=0; 
        

        
        distance= round(sqrt(((double(row1)-double(row2))^2)+((double(col1)-double(col2))^2)));
        
        circle_details_array(index,1)=min_row1;
        circle_details_array(index,2)=max_row1;
        circle_details_array(index,3)=min_col1;
        circle_details_array(index,4)=max_col1;
        circle_details_array(index,5)=min_row2;
        circle_details_array(index,6)=max_row2;
        circle_details_array(index,7)=min_col2;
        circle_details_array(index,8)=max_col2;
        circle_details_array(index,9)=distance;
        
        index=index+1;
        
    else 
        tag=false;
    end

end

%find max distance between two circle
max_distance=max(circle_details_array(:,9));


details_index=1;
for i=1:index-1
    if(circle_details_array(i,9)==max_distance)
       f_min_row_1=circle_details_array(i,1);
       f_max_row_1=circle_details_array(i,2);
       f_min_col_1=circle_details_array(i,3);
       f_max_col_1=circle_details_array(i,4);
       f_min_row_2=circle_details_array(i,5);
       f_max_row_2=circle_details_array(i,6);
       f_min_col_2=circle_details_array(i,7);
       f_max_col_2=circle_details_array(i,8);
       break; 
    end
end

final_im=uint8(zeros(M,N,3));
final_im(f_min_row_1:f_max_row_1,f_min_col_1:f_max_col_1,:)=main_im(f_min_row_1:f_max_row_1,f_min_col_1:f_max_col_1,:);
final_im(f_min_row_2:f_max_row_2,f_min_col_2:f_max_col_2,:)=main_im(f_min_row_2:f_max_row_2,f_min_col_2:f_max_col_2,:);

imshow(main_im);
figure;
imshow(final_im);
title(max_distance);

disp('number of circle=');
disp((index-1)*2);
