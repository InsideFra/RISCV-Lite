class RegisterFileClass():
    def __init__(self):
        self.register_value = [] # Register File variables
        # Populate the register file variables as 0 at the startup
        for i in range(0, 32, 1):
            self.register_value.append(0)

    def _get_value_from_register(self, rs1: int) -> int: 
        """Get a value from the register rs1

        Args:
            rs1 (int): The register address

        Returns:
            int: The value inside the register
        """
        assert type(rs1) == int
        assert (rs1 <= 31) & (rs1 >= 0)

        return self.register_value[rs1]

    def get_value_from_register(self, rs1: int) -> int:
        raise NotImplementedError()

    def _write_value_into_register(self, rd: int, value: int) -> None:
        assert type(rd) == int
        assert type(value) == int
        assert (rd <= 31) & (rd > 0)

        self.register_value[rd] = value
    
    def write_value_into_register(self, rd: int, value: int) -> None:
        raise NotImplementedError()
