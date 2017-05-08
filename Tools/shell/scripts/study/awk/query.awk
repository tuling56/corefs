#!/usr/bin/awk -f


BEGIN{FS="_"}

{
	if(NR%2==0)
		print NR,"===2";

	for(i=1;i<=NF;i++)
		dict[i,$i]++;

}


END{
	for(d in dict)
	{
		split(d,idx,SUBSEP);
		print idx[1],idx[2],dict[d];
	}
}
