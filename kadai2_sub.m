% pos画像50枚分のファイル名リストを作成
n=0; list1={};
LIST1={'pos2'};
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
LIST2={'bgimg'};
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

% その他の画像のファイル名リストを作成
n=0; list3={};
LIST3={'test'};
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