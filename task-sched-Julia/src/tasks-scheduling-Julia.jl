#
# Optimal Task Scheduler:
#
# Create the smallest-total-time schedule for N uninterrupted (no pauses) task 'programs' for
# a specific set of shared resource items. The script does exhaustive (combinatorial)
# search for finding the global optimum and has inherent complexity of O( N!.R.E[T] )
# where N=#tasks, R=#resources and E{T} is the mean value of the path in time slots, i.e.,
#  min{Tj} <= E[Tj] <= sum{Tj} , j=1..N

# declare necessary package imports
using Printf;           # for console output (print)
using Combinatorics;    # for creating vector permutations

# task programs: element=resourceID at time i
tasks_R::Int16=3;     # temporary placeholder for #resources 
tasks_C::Int16=8;     # temporary placeholder for max #slots per task 
tasks_prg=zeros(Int16,tasks_R,tasks_C);   # 'programs' per task 
tasks_sz=zeros(Int16,tasks_R,1);          # true 'program' sizes 
tasks_t0=zeros(Int16,tasks_R,1);          # startup delay (offset)

# define 'program' per task (zero-padded, update true size)
tasks_prg[1,:] = [1,1,2,1,3,4,3,5];  tasks_sz[1]=8;
tasks_prg[2,:] = [1,3,3,4,5,0,0,0];  tasks_sz[2]=5;
tasks_prg[3,:] = [2,2,3,3,3,0,0,0];  tasks_sz[3]=5;


# scan task 'programs', retrieve #resources and max slot (sum)
function get_sched_sizes()
    resN=0;  slotsN=0;
    for i in 1:length(tasks_sz)
        resN=maximum( [resN maximum(tasks_prg[i,:])] );
        slotsN=slotsN+tasks_sz[i];
    end
    return Int(resN), Int(slotsN);    # use proper type-casting wrappers
end

# check for any 'program' collision for specific schedule and allocation 
function has_collision( S, prg, t0, prg_len )
    found=-1;
    for i in 1:prg_len
        # terminate on out-of-bounds or any slot already allocated
        # Note: non-pausing assumption for all tasks, i.e., shift
        # it forward (delayed start) until no overlap exists.
        if (i+t0>size(S,2)) || S[prg[i],i+t0]>0
            found=i;
            break;
        end
    end
    return (found>0);     # boolean status as return value 
end

# allocate a task 'program' in the first available complete frame (non-pausing)
function alloc_slots( S, taskid, prg, prg_len )
    t0=0;
    while has_collision(S,prg,t0,prg_len)
        t0=t0+1;       # shift forward until an open frame is found 
    end

    if t0>size(S,2)    # guard against possible overrun (this should not happen)
        t0=-1; 
    else 
        for i in 1:prg_len
            # fill-in the entire task 'program' in the schedule 
            S[prg[i],i+t0]=taskid;
        end
    end
    return t0,S;       # return starting offset and updated schedule 
end

# trim the schedule matrix, delete all-zeros at tail 
function get_sched_trimmed( S )
    t=1;
    while (t<size(S,2)) && (sum(S[:,t])>0)
        t += 1;
    end
    Strim=S[:,1:t-1];
    tsum=size(Strim,2);

    return tsum,Strim;    # return new run length (min) and new schedule 
end


# ...... main routine for optimal schedule creation .....

res_sz, slots_sz = get_sched_sizes();

@printf("Task scheduling optimizer\n=> tasks=%d, resources=%d, slots.max=%d\n\n\n",tasks_R,res_sz,slots_sz);

# keep best solution as global variable 
SM_best=zeros(Int16,res_sz,slots_sz);
tlen_best=slots_sz;
tn_best=1;

# create all permutations for tasks sequencing (startup)
tasks_list0=1:length(tasks_sz);
tasks_perms=collect(permutations(tasks_list0,length(tasks_list0)));

# main loop: for each tasks sequence (in permutations)
for tn in 1:size(tasks_perms,1)
    tasks_list=tasks_perms[tn,:];
    SM=zeros(Int16,res_sz,slots_sz);

    tasks_list=tasks_list[1];
    @printf("Testing tasks sequence %d of %d:\n",tn,size(tasks_perms,1));
    show(tasks_list);

    # for each task in current tasks sequence
    for k in tasks_list
        @printf("\n\ttask %d program:  ",k); show(tasks_prg[k,:]);
        @printf("\n\ttask %d length:   %d",k,tasks_sz[k,1]);
        # best-fit allocation of task in the current schedule
        t0,SM = alloc_slots(SM,k,tasks_prg[k,:],tasks_sz[k,1]);
        display(SM);
        # update startup offset (delay) for current task 
        tasks_t0[k]=t0;
        # display updated schedule after task allocation
        @printf "\n\tnew allocation table (t0=%d):\n" tasks_t0[k];
        display(SM);
    end

    # trim the current schedule after all tasks have been allocated 
    tmplen,tmpSM = get_sched_trimmed(SM);
    # check if the solution is the new best 
    if tmplen<tlen_best
        global SM_best=tmpSM;
        global tlen_best=tmplen;
        global tn_best=tn;
        @printf("=> found new best schedule (tlen=%d) for sequence %d:\n",tlen_best,tn_best);
        display(SM_best);
    end
end

# all tasks sequences checked, display final results
@printf("\n\nBest solution found (tlen=%d):\n=> Tasks sequence %d: ",tlen_best,tn_best);
show((tasks_perms[tn_best,:])[1]);    # Note: extract as vector from single-element list
@printf("\n=> Tasks scheduling (res\\slots): \n");
display(SM_best);
