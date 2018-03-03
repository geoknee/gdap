% script to generate a number of simulated datasets
addpath('./QETLAB-0.9')
addpath('./QETLAB-0.9/helpers')
clear;
ensemble_size = 20;


for d=2:2
    dir = sprintf('./TNIbenchmarking_results/d%i',d);
    fprintf(newline);
    fprintf('%d: ', d);
    A = PM_minimal(d);  
    
    for i=1:ensemble_size
        fprintf('%d ', i); 
        % generate random ground truth
        choi_ground     = rand(d*d,d*d)-rand(d*d,d*d)+1.0j*rand(d*d,d*d)-1.0j*rand(d*d,d*d);
        choi_ground_vec = reshape(choi_ground,[],1);
        choi_ground_vec = CPTNI_project(choi_ground_vec); % consider replacing with USp for random p. i.e. like TNI but subnormalised to some random 0<p<1.
        choi_ground     = reshape(choi_ground_vec,[],d*d);
        if min(eig(choi_ground))<-1e-16
            sprintf('choi matrix not PSD')
            eig(choi_ground)
        end

        p               = real(A*choi_ground_vec);
%         p               = p/sum(p);
        % n             = mnrnd(1e4,p)';
        % n             = n/sum(n); % activate for multinomial noise
        
        n               = p; % noiseless scenario
%         
        [choi_ml_vecTP, ~, ~]  = gdapB(A,n);
        choi_mlTP = reshape(choi_ml_vecTP,[],d*d);

        [choi_ml_vecTNI, ~, ~] = TNIgdapB(A,n);
        choi_mlTNI = reshape(choi_ml_vecTNI,[],d*d);
% 
        errorTP(i) = trace_dist(choi_mlTP/trace(choi_mlTP),choi_ground/trace(choi_ground));
        errorTNI(i) = trace_dist(choi_mlTNI/trace(choi_mlTNI),choi_ground/trace(choi_ground));
% % save A as well, or assume fixed?
       
        save([dir,'/dataset',num2str(i)],'choi_ground','n','p')
    end
    
end