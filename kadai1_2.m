%{
%コードブックの作成
PosList=list1;
NegList=list2;
%NegList=list3;
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
save('codebook_kadai1.mat','codebook');
%}

%bog行列作成
%load('codebook_kadai1.mat'); % 最初にcodebook行列を読み込みます．
load('codebook_kadai1_2.mat');
n=length(Training);
bof = zeros(n,500);
for j=1:n % 各画像についての for-loop
    I=rgb2gray(imread(Training{j})); %j番目の画像読み込み
    %SURF特徴抽出(detectSURFFeatures と extractFeatures)
    p=detectSURFFeatures(I);
    [f,p2]=extractFeatures(I,p);
    for i=1:size(p2,1) % 各特徴点についての for-loop
        %一番近いcodebook中のベクトルを探してindexを求める．
        a = repmat(f(i,:), 500, 1);
        b=(a-codebook).^2;
        c=sqrt(sum(b'));
        [M,index] = min(c);
        % bofヒストグラム行列のj番目の画像のindexに投票
        bof(j,index)=bof(j,index)+1;
    end
end
bof = bof ./ sum(bof,2);

% 5-fold cross validationによる評価
data_pos=bof(1:100,:);
%data_neg=bof(101:300,:);
data_neg=bof(101:200,:);

%n=length(list2);
n=length(list3);
cv=5;
idx=1:100;
idx2=1:n;
accuracy=[];
% idx番目(idxはcvで割った時の余りがi-1)が評価データ
% それ以外は学習データ
for i=1:cv
    train_pos=data_pos(mod(idx,cv)~=(i-1),:);
    eval_pos =data_pos(mod(idx,cv)==(i-1),:);
    train_neg=data_neg(mod(idx2,cv)~=(i-1),:);
    eval_neg =data_neg(mod(idx2,cv)==(i-1),:);
    train=[train_pos; train_neg];
    eval=[eval_pos; eval_neg];
    train_label=[ones(size(train_pos,1),1); ones(size(train_neg,1),1)*(-1)];
    eval_label =[ones(size(eval_pos,1),1); ones(size(eval_neg,1),1)*(-1)];
    %学習
    %model = fitcsvm(train, train_label,'KernelFunction','linear');
    model = fitcsvm(train, train_label,'KernelFunction','rbf', 'KernelScale','auto');
    %分類
    %ac = 評価(認識精度値を出力)
    [plabel,score]=predict(model,eval);
    ac = numel(find(eval_label==plabel))/numel(eval_label);
    accuracy = [accuracy ac]
end
fprintf('accuracy: %f\n',mean(accuracy))

