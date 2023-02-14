% network, 入力画像を準備します．
net = vgg16;
for i=1:25
    %Image Read
    Imgfilename = list1{1,i};
    img=imread(Imgfilename);
    reimg = imresize(img,net.Layers(1).InputSize(1:2));
    if(i==1)
        IM=reimg;
    else
        IM=cat(4,IM,reimg);
    end
end

dcnnf = activations(net,IM,'fc7');
% squeeze関数で，ベクトル化します．
dcnnf = squeeze(dcnnf);
% L2ノルムで割って，L2正規化．
% 最終的な dcnnf を画像特徴量として利用します．
dcnnf = dcnnf/norm(dcnnf);
dcnnf = dcnnf'; 
data_pos=dcnnf;

for i=1:length(list2)
    %Image Read
    Imgfilename2 = list2{1,i};
    img2=imread(Imgfilename2);
    reimg2 = imresize(img2,net.Layers(1).InputSize(1:2));
    if(i==1)
        IM2=reimg2;
    else
        IM2=cat(4,IM2,reimg2);
    end
end
dcnnf2 = activations(net,IM2,'fc7');
% squeeze関数で，ベクトル化します．
dcnnf2 = squeeze(dcnnf2);
% L2ノルムで割って，L2正規化．
% 最終的な dcnnf を画像特徴量として利用します．
dcnnf2 = dcnnf2/norm(dcnnf2);
dcnnf2 = dcnnf2'; 
data_neg=dcnnf2;

cv=5;
idx=1:25;
idx2=1:length(list2);
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
  % 降順 ('descent') でソートして，ソートした値とソートインデックスを取得します．
  [sorted_score,sorted_idx] = sort(score(:,2),'descend');
for i=1:numel(sorted_idx)
  fprintf('%s %f\n',list{sorted_idx(i)},sorted_score(i));
end
