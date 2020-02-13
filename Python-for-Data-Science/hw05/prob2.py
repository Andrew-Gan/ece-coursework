from scipy.stats import norm
import numpy as np

def get_interv(data, conf, pop_dev):
    sample_mean = np.mean(data)
    z = norm.ppf(1 - (1 - conf) / 2)
    if(pop_dev == -1):
        std_dev = np.std(data)
    else:
        std_dev = pop_dev
    std_err = std_dev / np.sqrt(len(data))
    low_val = sample_mean - (z * std_dev) / np.sqrt(len(data))
    high_val = sample_mean + (z * std_dev) / np.sqrt(len(data))
    return sample_mean, std_err, std_dev, (low_val, high_val)

def get_conf(data, low_val):
    sample_mean = np.mean(data)
    z = (sample_mean - low_val) * np.sqrt(len(data)) / np.std(data)
    conf = (norm.cdf(z) - 1) * 2 + 1
    return conf

def main():
    data = [3, -3, 3, 12, 15, -16, 17, 19, 23, -24, 32]

    print('Info for q1 and q2')
    for k in [0.95, 0.90]:
        [mean, err, stat, (low, high)] = get_interv(data, k, -1)
        print('Sample mean          = %4.4f' %mean)
        print('Standard error       = %4.4f' %err)
        print('Standard statistic   = %4.4f' %stat)
        print('Interval             = (%4.4f, %4.4f)\n' %(low, high))

    print('Info for q3')
    [mean, err, stat, (low, high)] = get_interv(data, 0.95, 16.836)
    print('Sample mean          = %4.4f' %mean)
    print('Standard error       = %4.4f' %err)
    print('Standard statistic   = %4.4f' %stat)
    print('Interval             = (%4.4f, %4.4f)' %(low, high))

    print('\nInfo for q4')
    print('Level of confidence  = %4.4f' %get_conf(data, 1))

main()