% HW1: Basic Digital Image Processing Operations
% Due on 03/01/2020 (11:00 pm)
% Joseph Morga & Brandon Fong
% TODO organize into the format required by Kumar

%% 1. Read and display the image using Matlab (10 points). %%

% rgbImage is a 3d matrix
rgbImage = imread('Flooded_house.jpg','jpg');            %Changed path so that
[rows, columns, numberOfColorChannels] = size(rgbImage); %my computer would not
                                                         %give me erros
                                                         %when running the
                                                         %script
rgbImage(:,:,1); % red component
% disp('^ Red Component');
rgbImage(:,:,2); % idk component
% disp('^ Green Component');
rgbImage(:,:,3); % idk component
% disp('^ Blue Component');

% Display the image
% figure, imshow(rgbImage);title('Original');

%% 2. Display each band (Red, Green and Blue) of the image file (15 points) %%
% Hint: Red = I[:][:][1] captures the read component of the image %
% and stores it into array Red.%%%

% I don't know if I am supposed to really the red components
% This was my first attempt:
% 
% PartArray = rgbImage(:,:,1); % Red component
% figure, imshow(PartArray);title('PartArray');

% [Sources]
% https://www.mathworks.com/matlabcentral/answers/90908-r-g-b-components-of-an-image

RedPartArray = rgbImage(:,:,1); % Red component
Red = zeros(size(RedPartArray));
RedPart = cat(3, RedPartArray, Red, Red);
% figure, imshow(RedPart);title('Red');


GreenPartArray = rgbImage(:,:,2); % Green component
Green = zeros(size(GreenPartArray));
GreenPart = cat(3, Green, GreenPartArray, Green);
% figure, imshow(GreenPart);title('Green');

BluePartArray = rgbImage(:,:,3); % Blue component
Blue = zeros(size(BluePartArray));
BluePart = cat(3, Blue, Blue, BluePartArray);
% figure, imshow(BluePart);title('Blue');

%% 3. Convert the image into YCbCr color space: (5 points) %%

% 3.1. Matlab provides a command �rgb2ycbcr� to convert an %
% RGB image into a YCbCr image. %

ycbcr=rgb2ycbcr(rgbImage);
% disp('^ RGB to YCbCr')

% 3.2. Matlab also provides a command �ycbcr2rgb� to %
% convert a YCbCr image into RGB format. %

RGBFromYCbCr=ycbcr2rgb(rgbImage);
% disp('^ YCbCr to RGB')

%% 4. Display each band separately (Y, Cb and Cr bands). (10 points) %%

% figure, imshow(ycbcr(:,:,1)); title('ycbcr: Y component');
% 
% figure, imshow(ycbcr(:,:,2)); title('ycbcr: Cb component');
% 
% figure, imshow(ycbcr(:,:,3)); title('ycbcr: Cr component');

%% 5. Subsample Cb and Cr bands using 4:2:0 and display both bands. (10 points) %%

% refer to tips provided in 'MATLAB Commands_ HW1.pdf'
Y = 1; Cb = 2; Cr = 3;

% use a for loop to access the cr and cb components and then imshow to
% Does the index start at 0?


% for r = 1:rows
%     for c = 1:columns
%         % for every row, go through every column
%         % if the row number is even OR the column is even, 
%         % zero out all Cb and Cr for that index
%         
%         if (mod(r, 2) == 0) || (mod(c, 2) == 0) % I hope this logic makes sense
%             ycbcr(r, c, Cb) = 0;
%             ycbcr(r, c, Cr) = 0;
%         end
%     end
% end

%I dont think we are supposed to zero out all even rows and columns,
%I understood that we have to remove them.


%Copying all odd rows and columns from ycbcr into matrix ycbcrSubsampled

ycbcrSubsampled(:,:,Cb:Cr) = ycbcr(1:2:end,1:2:end,Cb:Cr);  
                                               
luma(:,:,Y) = ycbcr(:,:,Y);        %After doing this the subsampled
                                   %images look like the original ones
                                   %but smaller

                                               
% TODO this does not look like the sample outputs
% figure, imshow(ycbcrSubsampled(:,:,Cb)); title('ycbcr: Cb Subsampled');
% figure, imshow(ycbcrSubsampled(:,:,Cr)); title('ycbcr: Cr Subsampled');

%% 6. Upsample and display the Cb and Cr bands using: (15 points) %%

% 6.1. Linear interpolation %

% For odd row, compute the missing pixel as an average of the
% pixels in its right and left sides.

% For even rows, compute the missing pixel as an average of the
% pixels in its top and bottom sides.

% [SubsampledRow, SubsampledColumn, SubsampledChannels] = size(ycbcrSubsampled);

ycbcrReconstructed = luma(:,:,Y);

% rCount = 1;
% cCount = 1;

%Copying all pixels from ycbcrSubsampled into ycbcrReconstructed at every
%odd location

%work in progress

ycbcrReconstructed(1:2:end,1:2:end,Cb:Cr) = ycbcrSubsampled(:,:,Cb:Cr);

oddPixelRows = (ycbcrSubsampled(:,1:1:end-1,Cb:Cr) + ycbcrSubsampled(:,2:1:end,Cb:Cr))/2;

% if(mod(columns,2) == 0)
%     oddPixelRows(:,end,Cb-1:Cr-1) = oddPixelRows(:,end-1,Cb-1:Cr-1);
% end

evenPixelRows = (ycbcrSubsampled(1:1:end-1,:,Cb:Cr) + ycbcrSubsampled(2:1:end,:,Cb:Cr))/2;

% if(mod(rows,2) == 0)
%     evenPixelRows (end,:,Cb-1:Cr-1) = evenPixelRows (end-1,:,Cb-1:Cr-1);
% end

ycbcrReconstructed(1:2:end,2:2:end-1,Cb:Cr) = oddPixelRows(:,:,Cb-1:Cr-1);
ycbcrReconstructed(2:2:end-1,:,Cb:Cr) = (ycbcrReconstructed(1:2:end-2,:,Cb:Cr) + ycbcrReconstructed(3:2:end,:,Cb:Cr))/2;



% for r=1:rows
%     for c=1:columns          %this works but Im working on something simpler above
%         if(mod(c,2) == 0)        
%             if(c == columns)
%                 ycbcrReconstructed(r,c,Cb) = ycbcrReconstructed(r,c-1,Cb);
%                 ycbcrReconstructed(r,c,Cr) = ycbcrReconstructed(r,c-1,Cr);
%             else
%                 ycbcrReconstructed(r,c,Cb) = (ycbcrReconstructed(r,c-1,Cb) + ycbcrReconstructed(r,c+1,Cb))/2;
%                 ycbcrReconstructed(r,c,Cr) = (ycbcrReconstructed(r,c-1,Cr) + ycbcrReconstructed(r,c+1,Cr))/2;
%             end
%         end
%     end
% end
% 
% for r=1:rows
%     for c=1:columns
%         if(mod(r,2) == 0)
%             if(r == rows)
%                 ycbcrReconstructed(r,c,Cb) = ycbcrReconstructed(r-1,c,Cb);
%                 ycbcrReconstructed(r,c,Cr) = ycbcrReconstructed(r-1,c,Cr);
%             else
%                 ycbcrReconstructed(r,c,Cb) = (ycbcrReconstructed(r-1,c,Cb) + ycbcrReconstructed(r+1,c,Cb))/2;
%                 ycbcrReconstructed(r,c,Cr) = (ycbcrReconstructed(r-1,c,Cr) + ycbcrReconstructed(r+1,c,Cr))/2;
%             end
%         end
%     end
% end


figure, imshow(ycbcrReconstructed); title('Reconstructed'); %Just to see what Im getting

figure, imshow(ycbcr); title('Original'); %Original
