import Public
import Test

using Test: @testset
using Test: @test

@testset "Public.jl package" begin
    @testset "_is_valid_macro_expr" begin
        good_exprs = [
            :(@hello),
            Meta.parse("@hello"),
        ]
        bad_exprs = [
            Meta.parse("@foo bar"),
            Meta.parse("@foo(bar)"),
        ]
        for expr in good_exprs
            @testset let context = (; expr)
                @test Public._is_valid_macro_expr(expr)
            end

        end
        for expr in bad_exprs
            @testset let context = (; expr)
                @test !Public._is_valid_macro_expr(expr)
            end
        end
    end
end

module TestModule1

using Public: @public

export f
@public g

function f end
function g end
function h end

end # module TestModule1

@test Base.isexported(TestModule1, :f)
@test !Base.isexported(TestModule1, :g)
@test !Base.isexported(TestModule1, :h)

# @test Base.ispublic(TestModule1, :f)
# @test !Base.ispublic(TestModule1, :h)

@static if Base.VERSION >= v"1.11.0-DEV.469"
    # @test Base.ispublic(TestModule1, :g)
else
    # @test !Base.ispublic(TestModule1, :g)
end
