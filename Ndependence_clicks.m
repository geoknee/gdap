% script to investigate algorithm performance as a function of N
% script to generate a number of simulated datasets

%% check global variable set
if exist('ensemble')
   fprintf(['ensemble = ',ensemble])
else
    error('you must set the ensemble variable to either qp (quasi pure) or fr (full rank)')
end

if exist('drange')
    fprintf(['drange = ',drange])
else
    error('you must set the drange variable')
end

if exist('LIswitch')
    fprintf(['LIswitch = ',LIswitch])
else
    error('you must set the LIsiwtch variable (if 0 Linear Inversion is run, if 1 it is not)')
end

if exist('ensemble_size')
    fprintf(['ensemble_size = ',ensemble_size])
else
    error('you must set the ensemble_size variable')
end

if exist('Npows')
    fprintf(['Npows = ',ensemble_size])
else
    error('you must set the Npows variable')
end


%%
for d=drange
    
    fprintf(char(10));
    fprintf('%d ', d);
    A = PM_minimal(d);
%     A = GGMall_IO(d);
    
    % precompute matrices for TP_project
    M = zeros([d*d,d*d*d*d]);
    for i=1:d
        e = zeros(1,d);
        e(i)  = 1;
        B = kron(eye(d),e); 
        M = M + kron(B,B);
    end
    MdagM = sparse(M'*M);
    b = sparse(reshape(eye(d),[],1));
    Mdagb = sparse(M'*b);
    
    
    for l=1:ensemble_size
        fprintf('%d ', l); 
        % generate random ground truth

        switch ensemble
            case 'qp'
                choi_ground     = randomCPTP_quasi_pure(d,0.9);
            case 'fr'
                choi_ground     = randomCPTP(d,d*d); % kraus rank is full.
        end
                
%         partial_trace(choi_ground)
        choi_ground_vec = reshape(choi_ground,[],1);

        p               = real(A*choi_ground_vec);

        
        for Npow=Npows % above Npow=9 the memory requirements are huge for simulating multinomial noise                            

            N = 10^Npow;
            
            if isinf(N)

                n           = p;

            else
                pmat           = reshape(p,[],2*d*d); % need an object with n_measurement_outcomes columns
                pmat           = pmat./sum(pmat,2); % does not look necessary but it is useful to avoid near misses where probs sum to 1-e.

                nmat        = mnrnd(N,pmat);
                nmat        = nmat./sum(nmat,2); % proper normalisation so that sum(nmat,2)=1
                n           = reshape(nmat,[],1);
                

            end

            dir = sprintf('./Ndependence_benchmarking_results/d%i/Npow%i',d,Npow);
            save([dir,'/dataset',num2str(l)],'choi_ground','n','p')
            
        end
    end
    
end