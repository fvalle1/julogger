using Pages
using HTTP
using JSON
using Dates

Endpoint("/hello") do request::HTTP.Request
"Hello world"
end

Endpoint("/echo") do request::HTTP.Request
        params = HTTP.queryparams(HTTP.URI(request.target).query)
        println("Body: $(params)")
        open("logfile.txt", "a") do io
            println(io, params["id"])
        end
        response = JSON.json(params)
end

Endpoint("/echo",POST) do request::HTTP.Request
        data = String(request.body)
        open("logfile.txt","a") do io
		println("Parameters: $(data)")
		print(io, data)
        println(io, Dates.format(now(), " dd/mm/yyyy HH:MM"))
        end
        response = JSON.json(Dict(:data => data))
end

Endpoint("/") do request::HTTP.Request
    read(joinpath(@__DIR__,"index.html"),String)
end

open("logfile.txt", "r") do io
    a = readlines(io)
    # print([parse(Int,x[1]) for x in a])
    print(a)
end

@async Pages.start(8000);
