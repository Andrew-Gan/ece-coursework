import numpy as np
import scipy.stats as stats

def read_file(filename):
    fp = open(filename)
    data = fp.readlines()
    for k in range(0, len(data)):
        data[k] = float(data[k])
    fp.close()
    return(data)

def stat_param(arr, pop_mean):
    sample_size = len(arr)
    sample_mean = np.mean(arr)
    std_dev = np.std(arr, ddof=1)
    std_err = std_dev / np.sqrt(sample_size)
    std_scr = (sample_mean - pop_mean) / std_err
    p_val = 2 * stats.norm.cdf(std_scr)
    return (sample_size, sample_mean, std_err, std_scr, p_val, std_dev)

def min_z(mean, std_dev):
    std_scr = stats.norm.ppf(0.05 / 2)
    std_err = (mean - 0.75) / std_scr
    size = (std_dev / std_err) ** 2
    return(std_err, size)

def t_test(smp_mean_1, smp_mean_2, std_dev_1, std_dev_2, size1, size2):
    diff_mean = smp_mean_1 - smp_mean_2
    std_dev = np.sqrt(((std_dev_1 ** 2) / size1) + ((std_dev_2 ** 2) / size2))
    se = std_dev / np.sqrt(size1 + size2)
    t = (0 - diff_mean) / std_dev
    p = 2 * stats.t.cdf(t, 1)
    return(se, t, p)

def main():
    arr1 = read_file('eng1.txt')
    (size_1, mean_1, err_1, z_1, p_1, std_dev_1) = stat_param(arr1, 0.75)
    (largeSE, minSize) = min_z(mean_1, std_dev_1)
    arr0 = read_file('eng0.txt')
    (size_2, mean_2, err_2, z_2, p_2, std_dev_2) = stat_param(arr0, 0.75)
    (se, t, p) = t_test(mean_1, mean_2, std_dev_1, std_dev_2, size_1, size_2)

    print('Info for Q2')
    a = [0.1, 0.05, 0.01]
    for k in a:
        if(p_1 > k):
            print('Significant at a = %8.2f' %k)
        else:
            print('Insignificant at a = %6.2f' %k)
    print('Sample sizes     = %8d' %size_1)
    print('Sample means     = %8.4f' %mean_1)
    print('Standard err     = %8.4f' %err_1)
    print('Standard score   = %8.4f' %z_1)
    print('P-values         = %8.4f' %p_1)

    print('\nInfo for Q3')
    print('Largest SE       = %8.4f' %largeSE)
    print('Mininum Size     = %8d' %minSize)

    print('\nInfo for Q5')
    print('Sample sizes     = %8d %8d' %(size_1, size_2))
    print('Sample means     = %8.4f %8.4f' %(mean_1, mean_2))
    print('Standard error   = %8.4f' %se)
    print('t-value          = %8.4f' %t)
    print('p-value          = %8.4f' %p)
    
main()
