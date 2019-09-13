#!/usr/bin/awk -f

BEGIN{
    a=0;
}

{
    a++;

}

END{
    print dt"\t"a;
}
