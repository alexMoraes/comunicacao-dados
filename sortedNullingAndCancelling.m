function y = sortedNullingAndCancelling(x, h)
    o = getOrder(h);
    s = sortMatrix(h, o);

    nc = nullingAndCancelling(x, s);
    r = revertSort(nc, o);
    
    y = complex(r, 0);
end