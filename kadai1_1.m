%database が 100x64行列 となって，100枚分の64次元からヒストグラムを記録
database1=[];
for i=1:length(list1)
    X=imread(list1{i});
    RED=X(:,:,1); GREEN=X(:,:,2); BLUE=X(:,:,3);
    X64=floor(double(RED)/64) *4*4 + floor(double(GREEN)/64) *4 + floor(double(BLUE)/64);
    X64_vec=reshape(X64,1,numel(X64));
    h=histcounts(X64_vec,0:64);
    h = h / sum(h); % 要素の合計が１になるように正規化します．
    database1=[database1; h];
end

%database が 100x64行列 となって，100枚分の64次元からヒストグラムを記録
database2=[];
for i=1:length(list2)
    X=imread(list2{i});
    RED=X(:,:,1); GREEN=X(:,:,2); BLUE=X(:,:,3);
    X64=floor(double(RED)/64) *4*4 + floor(double(GREEN)/64) *4 + floor(double(BLUE)/64);
    X64_vec=reshape(X64,1,numel(X64));
    h=histcounts(X64_vec,0:64);
    h = h / sum(h); % 要素の合計が１になるように正規化します．
    database2=[database2; h];
end

% 5-fold cross validationによる評価
data_pos=database1;
data_neg=database2;

n=length(list2);
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
    model = fitcsvm(train, train_label,'KernelFunction','linear');
    %分類
    %ac = 評価(認識精度値を出力)
    [plabel,score]=predict(model,eval);
    ac = numel(find(eval_label==plabel))/numel(eval_label);
    accuracy = [accuracy ac]
end
fprintf('accuracy: %f\n',mean(accuracy))

