function [ARV, Cal] = createARV(data, interval)
    addPath(data);
    
    ant0_0 = read_complex_binary("ArrayTest0_0");
    ant0_1 = read_complex_binary("ArrayTest1_0");
    ant0_2 = read_complex_binary("ArrayTest2_0");
    ant0_3 = read_complex_binary("ArrayTest3_0");
    
end
