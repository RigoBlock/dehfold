contract Dragowned {
    address public Dragowner;

    function Dragowned() {
        Dragowner = tx.origin;
    }

    modifier onlyDragowner {
        if (msg.sender == Dragowner)
        _
    }

    function transferDragownership(address newDragowner) onlyDragowner {
        Dragowner = newDragowner;
    }
}
