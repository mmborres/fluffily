module WoofsHelper

    def getBreeds
        bcaps = getArray "SELECT DISTINCT breed FROM dogs WHERE status='Available'"
        return bcaps
    end

    def getColors
        bcaps = getArray "SELECT DISTINCT color FROM dogs WHERE status='Available'"
        return bcaps
    end

    def getLocations
        bcaps = getArray "SELECT DISTINCT location FROM dogs WHERE status='Available'"
        return bcaps
    end

    def getArray selectstatement
        arr = ExecuteSql.run selectstatement, mode: :raw
        bcaps = []
        arr.each do |item|
            bcaps.append item[0].capitalize
        end
        return bcaps
    end

end
