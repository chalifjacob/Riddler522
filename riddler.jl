#= July 9, 2021 Riddler Express Solution by Jacob Chalif

Question:
Earlier this year, a new generation of Brood X cicadas had emerged in many parts of the U.S. This particular brood emerges every 17 years, while some other cicada broods emerge every 13 years. Both 13 and 17 are prime numbers — and relatively prime with one another — which means these broods are rarely in phase with other predators or each other. In fact, cicadas following a 13-year cycle and cicadas following a 17-year cycle will only emerge in the same season once every 221 (i.e., 13 times 17) years!

Now, suppose there are two broods of cicadas, with periods of A and B years, that have just emerged in the same season. However, these two broods can also interfere with each other one year after they emerge due to a resulting lack of available food. For example, if A is 5 and B is 7, then B’s emergence in year 14 (i.e., 2 times 7) means that when A emerges in year 15 (i.e., 3 times 5) there won’t be enough food to go around.

If both A and B are relatively prime and are both less than or equal to 20, what is the longest stretch these two broods can go without interfering with one another’s cycle? (Remember, both broods just emerged this year.) For example, if A is 5 and B is 7, then the interference would occur in year 15.
=#

# Solution:

# Returns array of year of emergence for first 40 cycles of length a and b
function riddler(a,b)
    ar=fill(0,40,2)
    ar[1,:] = [a,b]
    for i in 2:40
        ar[i,:] = ar[1,:] * i
    end
    return ar
end

# Array to track years where cycles are within 1 year or each other
overlap = fill(NaN,20,20,3); 

for A in 1:20 # cycle A between 1 and 20 years
    for B in A+1:20 # cycle B between A+1 and 20 years
        if gcd(A,B) == 1 # checks that A and B are relatively prime
            rid = riddler(A,B) # returns array of first 40 cycles
            for i in 1:40
                a = findfirst(abs.(rid[i,1] .- rid[:,2]) .<= 1)  # finds when they interfere
                if !isnothing(a)
                    if rid[a,2] > rid[i,1]
                        final = rid[a,2]
                    else
                        final = rid[i,1]
                    end
                    if (final < overlap[A,B,1]) | isnan(overlap[A,B,1]) # saves earliest interference year, A, B
                        overlap[A,B,1] = final
                        overlap[A,B,2] = A
                        overlap[A,B,3] = B
                    end
                end
            end
        end
    end
end                    

answer = maximum(filter(!isnan,overlap[:,:,1])) # Finds longest time until interference
Afin = findfirst(overlap[:,:,1] .== answer)[1] # Prints A
Bfin = findfirst(overlap[:,:,1] .== answer)[2] # Prints B