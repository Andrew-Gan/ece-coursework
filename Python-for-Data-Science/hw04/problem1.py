#Returns a new list r where each element in r is fun2(fun1(i)) for the 
#corresponding element in l
def composeMap(fun1, fun2, l) :
    r = map(compose(fun1,fun2),l)
    r = list(r)
    return r

#Returns a new list r where each element in r is fun(fun(i)) for the 
#corresponding element in l
def doubleMap(fun, l) :
    r = composeMap(fun,fun,l)
    return r

#Returns a new function f. f should take a single input i, and return 
#fun2(fun1(i))
def compose(fun1, fun2) :
    def retfun(i) :
        out = fun2(fun1(i))
        return out
    return retfun

#Returns a new function f. f should take a single input i, and return
#fun applied to i num_repeats times. In other words, if num_repeats is 1, f
#should return fun(i). If num_repeats is 2, f should return fun(fun(i)). If
#num_repeats is 0, f should return i.
def repeater(fun, num_repeats) :
    i = 0
    def retfun(n): return n
    while(i < num_repeats):
        retfun = compose(retfun,fun)
        i = i + 1
    return retfun
    
if __name__ == '__main__' :
    def test1(x) :
        return x * 2
    
    def test2(x) :
        return x - 3
        
    data = [2, 5, -10, -7, -7, -3, -1, 9, 8, -6]

    print(composeMap(test1, test2, data))
    print(composeMap(test2, test1, data))
    print(doubleMap(test1, data))
    
    f1 = compose(test1, test2)
    
    print(f1(4))
    
    print(list(map(f1, data)))
    
    f2 = compose(test2, test1)

    print(f2(4))

    print(list(map(f2, data)))
    
    z = repeater(test1, 0)
    once = repeater(test1, 1)
    twice = repeater(test1, 2)
    thrice = repeater(test1, 3)
    
    print("repeat 0 times: {}".format(z(5)))
    print("repeat 1 time: {}".format(once(5)))
    print("repeat 2 times: {}".format(twice(5)))
    print("repeat 3 times: {}".format(thrice(5)))
    
    
