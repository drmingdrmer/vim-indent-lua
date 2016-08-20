
    function foo()
    end

    function foo()
    end

    a, b, c =
            function_name(x,
                          y, z)

    x = y +
            c +
            variable

function foo()
end


function bar()
    foo()
end


function wrapper_func(a, b)


    local a = b


    if a == b then
        a = 0
        b = 0
    end


    if a == b then a = 0 end


    if a == b then a = 0
                   c = d end


    if a == b then a = 0
                   c = d
    end


    while a == b do
        a = 0
    end


    while a == b do a = 0
    end


    while a == b do a = 0
                    c = d
    end


    while a == b
    do a = 0
       c = d
    end


    while a == b
    do
        a = 0
        c = d
    end


    function foo(a, b)
    end


    a = function(a, b) end


    a = function(a, b) doit()
        bla()
    end


    function foo(a, b)
        foo()
    end


    function foo(a, b,
                 c)
        foo()
        foo()
    end


    function foo(
            a, b)
        a = b
    end


    function foo(
            a,
            b
    )
        foo()
    end

end

function foo()

    local a = {}


    local a = {a, b}


    local a = {a,
               b}


    local a = {a,
               b
    }

    local a = {a,
               -- comment
               b,
               -- comment
               c
    }

    local a = {a,

               b,

               c
    }

    local a = {
        a,
        b,

        c
    }


    {
        a = foo(
                a, b, {
                    1, 2, 3
                })
    }


    {
        a = function(a,
                     b)
            if a == b then
                a=10
            else
                b=5
            end
        end,

        b = function () while a == b do
            loop_do()
        end
        end
    }

    a = function(a,
                 b, c, d)

        if     a == b then a = 3
                           b = 4
                           c = 10
        elseif a == 3 then a = 5
                           b = 6
                           c = 7
        else a = 5
             b = 6
             c = 11
        end

    end


    if (a == b
        and (c == d
             or c == e))
    then
        doit()
    end


    function name() if a == b then
        doit()
    end
    end


    function name() if a == b then doit()
                                   a = 1 end
    end


    function name()

        if a == b then
            -- xx
            doit()
        elseif c == d then
            doit()
            doit()

        elseif d == e
        then
            -- what?
        else
            doit()
            doit()
        end

        foo()
    end


    local x = "1"


    local a, b, c =
            very_looooooong_function_name(x,
                                          y, z)

    local a, b, c =
            very_looooooong_function_name(
                    x, y, z)


    local x = y +
            c +
            auto_indent_very_loooooooooooooooooong_variable


    local x = y +
            c +
            d +
            auto_indent_very_loooooooooooooooooong_variable


    return { very, long, expr },
            err, err_mes


    local a = x + 3 +
            function abc(
                    a, b)
                doit()
            end

    -- comment +
    local a = x +
            3 + function abc(
                    a, b)
                doit()
            end
    -- comment,

    -- comment2
end


-- vim: foldlevel=10
