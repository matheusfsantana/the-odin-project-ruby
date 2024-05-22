def bubble_sort(array)

    for i in 0..array.length-1
        for j in 0..(array.length-2)
            if array[j] > array[j+1]
                aux = array[j]
                array[j] = array[j+1]
                array[j+1] = aux
            end
        end
    end
    array
end

p bubble_sort([4,3,78,2,0,2])
# expected result => [0, 2, 2, 3, 4, 78]

