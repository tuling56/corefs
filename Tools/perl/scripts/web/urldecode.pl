#引入模块  
use URI::Escape;  
print "--------urlencode------------\n";  
$encoded = uri_escape("10%:\\ is enough\n");   
print $encoded,"\n";
print "--------urldecode-----------\n";  
$decoded  = uri_unescape($encoded);  
print $decoded,"\n";
