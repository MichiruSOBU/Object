% sushi画像100枚分のファイル名リストを作成
n=0; list1={};
LIST1={'pos'};
DIR0='imgdir/';
for i=1:length(LIST1)
    DIR=strcat(DIR0,LIST1(i),'/');
    W=dir(DIR{:});
    for j=1:size(W)
        if (strfind(W(j).name,'.jpg'))
            fn=strcat(DIR{:},W(j).name);
            n=n+1;
            %fprintf('[%d] %s\n',n,fn);
            list1=[list1(:)' {fn}];
        end
    end
end

% その他の画像のファイル名リストを作成
n=0; list2={};
LIST2={'neg'};
for i=1:length(LIST2)
    DIR=strcat(DIR0,LIST2(i),'/');
    W=dir(DIR{:});
    for j=1:size(W)
        if (strfind(W(j).name,'.jpg'))
            fn=strcat(DIR{:},W(j).name);
            n=n+1;
            %fprintf('[%d] %s\n',n,fn);
            list2=[list2(:)' {fn}];
        end
    end
end

% dolphin画像のファイル名リストを作成
n=0; list3={};
LIST3={'neg2'};
for i=1:length(LIST3)
    DIR=strcat(DIR0,LIST3(i),'/');
    W=dir(DIR{:});
    for j=1:size(W)
        if (strfind(W(j).name,'.jpg'))
            fn=strcat(DIR{:},W(j).name);
            n=n+1;
            %fprintf('[%d] %s\n',n,fn);
            list3=[list3(:)' {fn}];
        end
    end
end
%{
%コードブックの作成
PosList=list1;
%NegList=list2;
NegList=list3;
Training=[PosList(:)' NegList(:)'];
%全画像についてSURF特徴を抽出
Features=[];
for i=1:length(Training)
    I=rgb2gray(imread(Training{i}));
    p=detectSURFFeatures(I);
    [f,p2]=extractFeatures(I,p);
    Features=[Features; f];
end

%kmeans でコードブックを作成
k=500;
[idx,codebook]=kmeans(Features,k);
save('codebook_kadai1_2.mat','codebook');
%}