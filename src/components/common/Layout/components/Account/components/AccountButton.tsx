import { Button } from "@chakra-ui/react"

const AccountButton = ({ children, width, height, fontSize, ...rest }) => (
  <Button
    _hover={{
      background: "black",
      color: "black",
    }}
    colorScheme="black"
    borderRadius="none"
    backgroundColor="black"
    height={height}
    width={width}
    color="yellow"
    fontFamily="VT323"
    fontSize={fontSize}
    {...rest}
  >
    {children}
  </Button>
)

export default AccountButton
